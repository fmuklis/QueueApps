-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl32_listDataBulanan]
	-- Add the parameters for the stored procedure here
	@tahun int,
	@bulan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH dataSrc AS(
		SELECT idPelayananIGD, rujukan, idJenisPerawatan, idStatusPasien
		  FROM dbo.transaksiPendaftaranPasien
		 WHERE idPelayananIGD IS NOT NULL AND idStatusPasien IS NOT NULL
			   AND YEAR(tglDaftarPasien) = @tahun AND MONTH(tglDaftarPasien) = @bulan
	)
	SELECT a.namaPelayananIGD, b.jmlPasienRujukan, c.jmlPasienNonRujukan, d.jmlPasienDirawat, e.jmlPasienDirujuk, f.jmlPasienPulang, g.jmlPasienMeninggal, h.jmlPasienDOA
	  FROM dbo.masterPelayananIGD a
		   OUTER APPLY (SELECT Count(xa.idPelayananIGD) AS jmlPasienRujukan
						  FROM dataSrc xa
					     WHERE xa.rujukan = 1/*Rujukan*/ AND xa.idPelayananIGD = a.idPelayananIGD) b
		   OUTER APPLY (SELECT Count(xa.idPelayananIGD) AS jmlPasienNonRujukan
						  FROM dataSrc xa
					     WHERE ISNULL(xa.rujukan, 0) = 0/*Non Rujukan*/ AND xa.idPelayananIGD = a.idPelayananIGD) c
		   OUTER APPLY (SELECT Count(xa.idPelayananIGD) AS jmlPasienDirawat
						  FROM dataSrc xa
					     WHERE idJenisPerawatan = 1/*RaNap*/ AND xa.idPelayananIGD = a.idPelayananIGD) d
		   OUTER APPLY (SELECT Count(xa.idPelayananIGD) AS jmlPasienDirujuk
						  FROM dataSrc xa
					     WHERE idJenisPerawatan = 2/*RaJal*/ AND xa.idStatusPasien IN(3,10)/*Dirujuk, Rujuk Balik*/
							   AND xa.idPelayananIGD = a.idPelayananIGD) e
		   OUTER APPLY (SELECT Count(xa.idPelayananIGD) AS jmlPasienPulang
						  FROM dataSrc xa
					     WHERE idJenisPerawatan = 2/*RaJal*/ AND xa.idStatusPasien IN(2,6)/*Selesai Perawatan, Kontrol Rawat Jalan*/
							   AND xa.idPelayananIGD = a.idPelayananIGD) f
		   OUTER APPLY (SELECT Count(xa.idPelayananIGD) AS jmlPasienMeninggal
						  FROM dataSrc xa
					     WHERE idJenisPerawatan = 2/*RaJal*/ AND xa.idStatusPasien = 5/*Meninggal Di UGD*/
							   AND xa.idPelayananIGD = a.idPelayananIGD) g
		   OUTER APPLY (SELECT Count(xa.idPelayananIGD) AS jmlPasienDOA
						  FROM dataSrc xa
					     WHERE idJenisPerawatan = 2/*RaJal*/ AND xa.idStatusPasien = 7/*DOA*/
							   AND xa.idPelayananIGD = a.idPelayananIGD) h
END