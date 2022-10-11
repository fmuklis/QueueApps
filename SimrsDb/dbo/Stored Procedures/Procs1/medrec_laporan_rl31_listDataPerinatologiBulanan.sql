-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl31_listDataPerinatologiBulanan]
	-- Add the parameters for the stored procedure here
	@tahun int,
	@bulan tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH pasienAwalTahun AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
			 WHERE YEAR(a.tanggalMasuk) < @tahun AND YEAR(a.tanggalKeluar) >= @tahun)
		,pasienMasuk AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
			 WHERE YEAR(a.tanggalMasuk) = @tahun AND MONTH(a.tanggalMasuk) = @bulan)
		,pasienKeluarHidup AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
				   INNER JOIN dbo.transaksiPendaftaranPasien d ON a.idPendaftaranPasien = d.idPendaftaranPasien
			 WHERE YEAR(a.tanggalMasuk) = @tahun AND MONTH(a.tanggalMasuk) = @bulan AND YEAR(a.tanggalKeluar) = @tahun
				   AND MONTH(a.tanggalKeluar) = @bulan AND d.idStatusPasien IN(1,2,3,4,6,11))
		,pasienKeluarMatiA AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
				   INNER JOIN dbo.transaksiPendaftaranPasien d ON a.idPendaftaranPasien = d.idPendaftaranPasien
			 WHERE YEAR(a.tanggalMasuk) = @tahun AND MONTH(a.tanggalMasuk) = @bulan AND YEAR(a.tanggalKeluar) = @tahun
				   AND MONTH(a.tanggalKeluar) = @bulan AND d.idStatusPasien IN(5,8))
		,pasienKeluarMatiB AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
				   INNER JOIN dbo.transaksiPendaftaranPasien d ON a.idPendaftaranPasien = d.idPendaftaranPasien
			 WHERE YEAR(a.tanggalMasuk) = @tahun AND MONTH(a.tanggalMasuk) = @bulan AND YEAR(a.tanggalKeluar) = @tahun
				   AND MONTH(a.tanggalKeluar) = @bulan AND d.idStatusPasien = 9)
		,lamaInap AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
				  ,DATEDIFF(DAY, a.tanggalMasuk, a.tanggalKeluar) AS lamaInap
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
				   INNER JOIN dbo.transaksiPendaftaranPasien d ON a.idPendaftaranPasien = d.idPendaftaranPasien AND d.idStatusPasien IS NOT NULL
			 WHERE YEAR(a.tanggalMasuk) = @tahun AND MONTH(a.tanggalMasuk) = @bulan AND YEAR(a.tanggalKeluar) = @tahun
				   AND MONTH(a.tanggalKeluar) = @bulan)
		,hariPerawatan AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
				  ,DATEDIFF(DAY, a.tanggalMasuk, a.tanggalKeluar) AS lamaInap
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
			 WHERE YEAR(a.tanggalMasuk) = @tahun AND MONTH(a.tanggalMasuk) = @bulan)
		,rincianPerkelas AS(
			SELECT COALESCE(a.idJenisPelayananRawatInap, c.idJenisPelayananRawatInap) AS idJenisPelayananRawatInap
				  ,CASE
						WHEN c.idKelas < 6
							 THEN c.idKelas
						ELSE 6 
					END AS kelasPerawatan
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				   LEFT JOIN dbo.masterRuanganRawatInap c ON b.idRuanganRawatInap = c.idRuanganRawatInap
			 WHERE (YEAR(a.tanggalMasuk) < @tahun AND YEAR(a.tanggalKeluar) >= @tahun) OR YEAR(a.tanggalMasuk) = @tahun)

	SELECT namaRuangan, jmlAwalTh, jmlMasuk, jmlHidup, matiA, matiB, ISNULL(lamaInap, 0) AS lamaInap, jmlAkhirTh
		  ,ISNULL(lamaDirawat, 0) AS lamaDirawat, ISNULL([1], 0) AS jmlVVIP, ISNULL([2], 0) AS jmlVIP, ISNULL([3], 0) AS jmlKlsI
		  ,ISNULL([4], 0) AS jmlKlsII, ISNULL([5], 0) AS jmlKlsIII, ISNULL([6], 0) AS jmlLain
	  FROM (SELECT jenisPelayananRawatInap AS namaRuangan, jmlAwalTh, jmlMasuk, jmlHidup, matiA, matiB, lamaInap, jmlAwalTh + jmlMasuk - jmlHidup - matiA - matiB AS jmlAkhirTh
				  ,lamaDirawat, kelasPerawatan, jumlahPerKelas
			  FROM dbo.masterJenisPelayananRawatInap a
				   OUTER APPLY (SELECT COUNT(idJenisPelayananRawatInap) AS jmlAwalTh
								  FROM pasienAwalTahun xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap) b
				   OUTER APPLY (SELECT COUNT(idJenisPelayananRawatInap) AS jmlMasuk
								  FROM pasienMasuk xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap) c
				   OUTER APPLY (SELECT COUNT(idJenisPelayananRawatInap) AS jmlHidup
								  FROM pasienKeluarHidup xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap) d
				   OUTER APPLY (SELECT COUNT(idJenisPelayananRawatInap) AS matiA
								  FROM pasienKeluarMatiA xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap) e
				   OUTER APPLY (SELECT COUNT(idJenisPelayananRawatInap) AS matiB
								  FROM pasienKeluarMatiB xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap) f
				   OUTER APPLY (SELECT SUM(lamaInap) AS lamaInap
								  FROM lamaInap xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap) g
				   OUTER APPLY (SELECT SUM(lamaInap) AS lamaDirawat
								  FROM hariPerawatan xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap) h
				   OUTER APPLY (SELECT kelasPerawatan, COUNT(idJenisPelayananRawatInap) AS jumlahPerKelas
								  FROM rincianPerkelas xa
								 WHERE xa.idJenisPelayananRawatInap = a.idJenisPelayananRawatInap
							  GROUP BY kelasPerawatan) i
			 WHERE a.perinatologi = 1/*Perinatal*/) AS srcPvt
	 PIVOT (MAX(jumlahPerKelas) FOR kelasPerawatan IN([1],[2],[3],[4],[5],[6])) AS dataPvt
END