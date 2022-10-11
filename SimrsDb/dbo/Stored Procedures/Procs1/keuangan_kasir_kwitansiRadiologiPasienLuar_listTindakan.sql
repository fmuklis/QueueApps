-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiRadiologiPasienLuar_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.idTindakanPasien, bb.namaTarif, bb.tarif, bb.qty, ba.diskonTunai, ba.diskonPersen, bb.jmlTarif
		  ,bc.idPenjualanDetail, bc.namaBHP, bc.tarifBHP, bc.jmlBHP, bc.jmlTarifBHP
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
				Inner Join dbo.transaksiTindakanPasien ba On b.idOrderDetail = ba.idOrderDetail
				Outer Apply dbo.getInfo_tarifTindakan(ba.idTindakanPasien) bb
				Outer Apply dbo.getInfo_bhpTindakan(ba.idTindakanPasien) bc
	 WHERE idBilling = @idBilling
  ORDER BY ba.idTindakanPasien
END