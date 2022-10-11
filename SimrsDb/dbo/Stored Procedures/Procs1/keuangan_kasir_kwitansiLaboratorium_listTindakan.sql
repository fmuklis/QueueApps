-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiLaboratorium_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.idTindakanPasien, bc.idPenjualanDetail, bb.namaTarif, bb.tarif, bb.qty, bb.diskonTunai, bb.diskonPersen, bb.jmlTarif
		  ,bc.namaBHP, bc.jmlTarifBHP, bc.tarifBHP, bc.jmlBHP, bc.jmlTarifBHP
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiOrderDetail b ON a.idOrder = b.idOrder
				INNER JOIN dbo.transaksiTindakanPasien ba ON b.idOrderDetail = ba.idOrderDetail
				OUTER APPLY dbo.getInfo_tarifTindakan(ba.idTindakanPasien) bb
				OUTER APPLY dbo.getInfo_bhpTindakan(ba.idTindakanPasien) bc
	 WHERE a.idBilling = @idBilling
  ORDER BY ba.idTindakanPasien
END