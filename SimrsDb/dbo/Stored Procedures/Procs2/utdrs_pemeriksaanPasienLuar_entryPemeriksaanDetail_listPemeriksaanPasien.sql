-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[utdrs_pemeriksaanPasienLuar_entryPemeriksaanDetail_listPemeriksaanPasien]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTindakanPasien, c.idPenjualanDetail, a.idRuangan, d.namaRuangan
		  ,a.tglTindakan, b.namaTarif, b.tarif, b.qty, b.jmlTarif, b.BHP
		  ,c.namaBHP, c.tarifBHP, c.jmlBHP, c.jmlTarifBHP
	  FROM dbo.transaksiTindakanPasien a
		   OUTER APPLY dbo.getInfo_tarifTindakan(a.idTindakanPasien) b
		   OUTER APPLY dbo.getInfo_bhpTindakan(a.idTindakanPasien) c
		   LEFT JOIN dbo.masterRuangan d On a.idRuangan = d.idRuangan
		   INNER JOIN dbo.transaksiOrderDetail f On a.idOrderDetail = f.idOrderDetail
	 WHERE f.idOrder = @idOrder
  ORDER BY a.tglTindakan
END