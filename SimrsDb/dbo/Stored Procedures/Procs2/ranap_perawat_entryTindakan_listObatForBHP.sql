-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Penjualan E-Resep
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_listObatForBHP]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT a.idObatDetail, b.namaObat, a.kodeBatch, a.tglExpired, a.stok, b.namaSatuanObat
	  FROM dbo.farmasiMasterObatDetail a                                                         
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b 
	 WHERE a.stok >= 1 AND a.idRuangan = @idRuangan AND a.tglExpired > GETDATE()
  ORDER BY b.namaObat, a.tglExpired
END