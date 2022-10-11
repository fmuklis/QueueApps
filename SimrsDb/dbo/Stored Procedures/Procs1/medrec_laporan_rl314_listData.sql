-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl314_listData]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH srcRujukan AS (
			SELECT a.idPendaftaranPasien, ba.jenisSpesialisasi, c.idJenisFaskes, a.idStatusPasien
			  FROM dbo.transaksiPendaftaranPasien a
				   INNER JOIN dbo.masterOperator b ON a.idDokter = b.idOperator
						INNER JOIN dbo.masterOperatorJenis ba ON b.idJenisOperator = ba.idJenisOperator
				   INNER JOIN dbo.masterAsalPasien c ON a.idAsalPasien = c.idAsalPasien
			 WHERE YEAR(a.tglDaftarPasien) = @tahun)
	SELECT DISTINCT a.jenisSpesialisasi, b.dariPuskesmas, c.dariFaskesLain, d.dariRsLain
		  ,e.dikembalikanKePuskesmas, f.dikembalikanKeFaskesLain, g.dikembalikanKeRsLain
		  ,h.pasienRujukan, i.pasienDatangSendiri, 0 AS diterimaKembali
	  FROM dbo.masterOperatorJenis a
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS dariPuskesmas
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi
							   AND xa.idJenisFaskes = 2/*PUSKESMAS*/) b
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS dariFaskesLain
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi
							   AND xa.idJenisFaskes = 3/*FASKES LAIN*/) c
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS dariRsLain
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi
							   AND xa.idJenisFaskes = 1/*RUMAHSAKIT*/) d
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS dikembalikanKePuskesmas
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi AND xa.idStatusPasien = 10/*Rujuk Balik*/
							   AND xa.idJenisFaskes = 2/*PUSKESMAS*/) e
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS dikembalikanKeFaskesLain
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi
							   AND xa.idJenisFaskes = 3/*FASKES LAIN*/ AND xa.idStatusPasien = 10/*Rujuk Balik*/) f
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS dikembalikanKeRsLain
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi AND xa.idStatusPasien = 10/*Rujuk Balik*/
							   AND xa.idJenisFaskes = 1/*RUMAHSAKIT*/) g
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS pasienRujukan
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi AND xa.idJenisFaskes BETWEEN 1 AND 3) h
		   OUTER APPLY (SELECT COUNT(xa.idPendaftaranPasien) AS pasienDatangSendiri
						  FROM srcRujukan xa
						 WHERE xa.jenisSpesialisasi = a.jenisSpesialisasi AND xa.idJenisFaskes = 4) i
	 WHERE a.jenisSpesialisasi IS NOT NULL
END