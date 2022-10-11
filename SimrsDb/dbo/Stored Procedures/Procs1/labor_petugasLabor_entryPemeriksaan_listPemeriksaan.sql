-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_listPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  a.idTindakanPasien, a.idOrderDetail, c.idPenjualanDetail, a.idMasterTarif 
		  ,a.tglTindakan, b.namaTarif, b.BHP, b.tarif, b.qty, b.jmlTarif
		  ,c.namaBHP, c.jmlBHP, c.tarifBHP, c.jmlTarifBHP
	  FROM dbo.transaksiTindakanPasien a
		   OUTER APPLY dbo.getinfo_tarifTindakan(a.idTindakanPasien) b
		   OUTER APPLY dbo.getinfo_bhpTindakan(a.idTindakanPasien) c
		   INNER JOIN dbo.transaksiOrderDetail d ON a.idOrderDetail = d.idOrderDetail
	 WHERE d.idOrder = @idOrder
END