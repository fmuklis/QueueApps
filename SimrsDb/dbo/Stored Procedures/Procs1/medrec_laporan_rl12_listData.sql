-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl12_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal int,
	@periodeAkhir int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @listTahun table(tahun int);

	INSERT INTO @listTahun
		 SELECT DISTINCT YEAR(tglDaftarPasien)
		   FROM dbo.transaksiPendaftaranPasien
		  WHERE YEAR(tglDaftarPasien) BETWEEN @periodeAwal AND @periodeAkhir;

	SELECT a.tahun
		  ,CAST(f.jmlLamaInap / (b.jmlTempatTidur * 365) * 100 AS decimal(18,2)) AS BOR
		  ,CAST(f.jmlLamaInap / e.jmlPulang AS decimal(18,2)) AS LOS
		  ,CAST(((b.jmlTempatTidur * 365) - f.jmlLamaInap) / e.jmlPulang AS decimal(18,2)) AS TOI
		  ,CAST(e.jmlPulang / b.jmlTempatTidur AS decimal(18,2)) AS BTO
		  ,CAST((c.jmlMatiSetelah / e.jmlPulang) * 1000 AS decimal(18,2)) AS NDR
		  ,CAST(((c.jmlMatiSetelah + d.jmlMati) / e.jmlPulang) * 1000 AS decimal(18,2)) AS GDR
		  ,CAST(e.jmlPulang / f.jmlLamaInap AS decimal(18,2)) AS rataRata
	  FROM @listTahun a
		   OUTER APPLY (SELECT COUNT(xa.idTempatTidur) AS jmlTempatTidur
						  FROM dbo.masterRuanganTempatTidur xa
							   INNER JOIN dbo.masterRuanganRawatInap xb On xa.idRuanganRawatInap = xb.idRuanganRawatInap
							   INNER JOIN dbo.masterRuangan xc On xb.idRuangan = xc.idRuangan
						 WHERE xc.idJenisRuangan = 2/*Ins RaNap*/ AND xa.flagMasihDigunakan = 1
							   AND xb.idKelas BETWEEN 1 AND 5) b
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS jmlMatiSetelah
						  FROM dbo.transaksiPendaftaranPasien xa
						 WHERE YEAR(xa.tglDaftarPasien) = a.tahun AND xa.idJenisPerawatan = 1/*RaNap*/
							   AND xa.idStatusPasien = 9/*pasien mati > 48 jam*/) c
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS jmlMati
						  FROM dbo.transaksiPendaftaranPasien xa
						 WHERE YEAR(xa.tglDaftarPasien) = a.tahun AND xa.idJenisPerawatan = 1/*RaNap*/
							   AND xa.idStatusPasien IN(5,8)/*pasien mati*/) d
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS jmlPulang
						  FROM dbo.transaksiPendaftaranPasien xa
						 WHERE YEAR(xa.tglDaftarPasien) = a.tahun AND xa.idJenisPerawatan = 1/*RaNap*/
							   AND xa.idStatusPasien IS NOT NULL) e
		   OUTER APPLY (SELECT SUM(xa.idPendaftaranPasien) AS jmlLamaInap
						  FROM dbo.transaksiPendaftaranPasien xa
							   INNER JOIN dbo.transaksiPendaftaranPasienDetail xb ON xa.idPendaftaranPasien = xb.idPendaftaranPasien
						 WHERE YEAR(xa.tglDaftarPasien) = a.tahun AND xa.idJenisPerawatan = 1/*RaNap*/
							   AND xa.idStatusPasien IS NOT NULL) f
END