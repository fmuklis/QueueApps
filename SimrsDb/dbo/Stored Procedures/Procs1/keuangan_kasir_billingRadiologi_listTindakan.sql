-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRadiologi_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.idTindakanPasien, bc.namaRuangan, bb.namaTarif, bb.tarif, bb.diskonTunai, bb.diskonPersen, bb.jmlTarif
		  ,e.discountTindakan AS flagDiscount
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiOrderDetail b ON a.idOrder = b.idOrder
				INNER JOIN dbo.transaksiTindakanPasien ba ON b.idOrderDetail = ba.idOrderDetail
				OUTER APPLY dbo.getInfo_tarifTindakan(ba.idTindakanPasien) bb
				LEFT JOIN dbo.masterRuangan bc ON ba.idRuangan = bc.idRuangan
		   OUTER APPLY (SELECT discountTindakan 
						 FROM dbo.sistemKonfigurasiKasir) e
	 WHERE a.idBilling = @idBilling
  ORDER BY bc.namaRuangan, a.idOrder
END