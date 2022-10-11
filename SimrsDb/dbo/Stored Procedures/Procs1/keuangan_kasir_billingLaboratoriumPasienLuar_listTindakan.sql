-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingLaboratoriumPasienLuar_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.idTindakanPasien, cb.namaRuangan, ca.namaTarif, ca.tarif, ca.diskonTunai
		  ,ca.diskonPersen, ca.jmlTarif, d.discountTindakan AS flagDiscount
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiOrderDetail b ON a.idOrder = b.idOrder
		   INNER JOIN dbo.transaksiTindakanPasien c ON b.idOrderDetail = c.idOrderDetail
				OUTER APPLY dbo.getInfo_tarifTindakan(c.idTindakanPasien) ca
				LEFT JOIN dbo.masterRuangan cb ON c.idRuangan = cb.idRuangan
		   OUTER APPLY(SELECT discountTindakan 
						 FROM dbo.sistemKonfigurasiKasir) d
	 WHERE a.idBilling = @idBilling
  ORDER BY cb.namaRuangan
END