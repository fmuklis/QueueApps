-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_stokBarangFarmasi_listData]
	-- Add the parameters for the stored procedure here
	@year int,
	@month tinyint,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @idJenisStok int;

	SELECT @idJenisStok = b.idJenisStok
	  FROM dbo.masterUser a
		   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
	 WHERE a.idUser = @idUserEntry;

	WITH srcData AS(
		SELECT MAX(a.idLog) AS idLog, a.idObatDetail, b.idObatDosis
		  FROM dbo.farmasiJurnalStok a
			   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
		 WHERE YEAR(DATEADD(MONTH, -1, a.tanggalEntry)) <= @year AND MONTH(DATEADD(MONTH, -1, a.tanggalEntry)) <= @month AND b.idJenisStok = @idJenisStok
	  GROUP BY a.idObatDetail, b.idObatDosis)

	/*SELECT *
	  FROM (
	SELECT c.namaBarang, a.kodeBatch, a.stok AS stokAwal, ISNULL(d.jumlahMasuk, 0) AS jumlahMasuk, ISNULL(d.jumlahKeluar, 0) AS jumlahKeluar
		  ,a.stok + ISNULL(d.jumlahMasuk, 0) - ISNULL(d.jumlahKeluar, 0) AS stokAkhir
	  FROM dbo.farmasiMasterObatDetail a
		   LEFT JOIN dbo.farmasiJurnalStok b ON a.idObatDetail = b.idObatDetail  AND YEAR(a.tanggalEntry) <= @year AND MONTH(a.tanggalEntry) <= @month - 1
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
		   OUTER APPLY (SELECT SUM(xa.jumlahMasuk) AS jumlahMasuk, SUM(xa.jumlahKeluar) AS jumlahKeluar
						  FROM dbo.farmasiJurnalStok xa
						 WHERE xa.idObatDetail = a.idObatDetail) d
	 WHERE b.idLog IS NULL AND a.stok >= 1 AND a.tglExpired > CAST(GETDATE() AS date) AND idJenisStok = @idJenisStok
	 UNION ALL*/
	SELECT b.namaBarang, c.kodeBatch, d.stokAkhir AS stokAwal, ISNULL(e.jumlahMasuk, 0) AS jumlahMasuk, ISNULL(e.jumlahKeluar, 0) AS jumlahKeluar
		  ,d.stokAkhir + ISNULL(e.jumlahMasuk, 0) - ISNULL(e.jumlahKeluar, 0) AS stokAkhir
	  FROM srcData a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   INNER JOIN dbo.farmasiMasterObatDetail c ON a.idObatDetail = c.idObatDetail
		   INNER JOIN dbo.farmasiJurnalStok d ON a.idLog = d.idLog
		   OUTER APPLY (SELECT SUM(xa.jumlahMasuk) AS jumlahMasuk, SUM(xa.jumlahKeluar) AS jumlahKeluar
						  FROM dbo.farmasiJurnalStok xa
						 WHERE xa.idObatDetail = a.idObatDetail AND xa.idLog > a.idLog) e--) setData
  ORDER BY namaBarang, kodeBatch

END