CREATE PROCEDURE [dbo].[medrec_laporan_pasienRaNapBujk_listData]
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN

	SET NOCOUNT ON;

	WITH dataSet AS
		 (SELECT 'ANAK-ANAK (30 Hari S/D 16 Th)' AS kelompokUmur, ba.namaJenisKelamin, a.idPendaftaranPasien
		    FROM dbo.transaksiPendaftaranPasien a
				 INNER JOIN dbo.masterPasien b ON a.idPasien = b.idPasien
					INNER JOIN dbo.masterJenisKelamin ba On b.idJenisKelaminPasien = ba.idJenisKelamin
		   WHERE DATEDIFF(DAY, b.tglLahirPasien, a.tglDaftarPasien) >= 30 AND DATEDIFF(YEAR, b.tglLahirPasien, a.tglDaftarPasien) <= 16
				 AND a.tglDaftarPasien BETWEEN @periodeAwal AND @periodeAkhir
		   UNION ALL
		  SELECT 'BAYI (0 S/D 30 Hari)' AS kelompokUmur, ba.namaJenisKelamin, a.idPendaftaranPasien
		    FROM dbo.transaksiPendaftaranPasien a
				 INNER JOIN dbo.masterPasien b ON a.idPasien = b.idPasien
					INNER JOIN dbo.masterJenisKelamin ba On b.idJenisKelaminPasien = ba.idJenisKelamin
		   WHERE DATEDIFF(DAY, b.tglLahirPasien, a.tglDaftarPasien) < 30 AND a.tglDaftarPasien BETWEEN @periodeAwal AND @periodeAkhir
		   UNION ALL
		  SELECT 'DEWASA (> 16 Th / Menikah)' AS kelompokUmur, ba.namaJenisKelamin, a.idPendaftaranPasien
		    FROM dbo.transaksiPendaftaranPasien a
				 INNER JOIN dbo.masterPasien b ON a.idPasien = b.idPasien
					INNER JOIN dbo.masterJenisKelamin ba On b.idJenisKelaminPasien = ba.idJenisKelamin
		   WHERE DATEDIFF(YEAR, b.tglLahirPasien, a.tglDaftarPasien) > 16 AND a.tglDaftarPasien BETWEEN @periodeAwal AND @periodeAkhir)
	SELECT *
	  FROM dataSet
	 PIVOT (COUNT(idPendaftaranPasien) FOR namaJenisKelamin IN([LAKI-LAKI],[PEREMPUAN])) piv;
END