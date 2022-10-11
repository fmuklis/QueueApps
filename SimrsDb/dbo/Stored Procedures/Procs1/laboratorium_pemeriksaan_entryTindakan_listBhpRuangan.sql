-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Penjualan E-Resep
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_entryTindakan_listBhpRuangan]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT a.idObatDetail, c.namaBarang, a.kodeBatch, a.tglExpired, a.stok, c.namaSatuanObat
	  FROM dbo.farmasiMasterObatDetail a
	 	   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
	 WHERE a.stok >= 1 AND a.tglExpired > GETDATE() AND a.idRuangan = @idRuangan
  ORDER BY c.namaBarang
END