-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRadiologiPasienLuar_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.idTindakanPasien, bc.namaRuangan, bb.namaTarif, bb.tarif, bb.diskonTunai, bb.diskonPersen, bb.jmlTarif
		  ,d.discountTindakan As flagDiscount
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
				Inner Join dbo.transaksiTindakanPasien ba On b.idOrderDetail = ba.idOrderDetail
				Outer Apply getInfo_tarifTindakan(ba.idTindakanPasien) bb
				Inner Join dbo.masterRuangan bc On ba.idRuangan = bc.idRuangan
		   Outer Apply(Select discountTindakan 
						 From dbo.sistemKonfigurasiKasir) d
	 WHERE a.idBilling = @idBilling
  ORDER BY bc.namaRuangan
END