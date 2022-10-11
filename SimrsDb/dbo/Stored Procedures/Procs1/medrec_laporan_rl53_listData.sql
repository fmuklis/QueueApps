-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl53_listData]
	-- Add the parameters for the stored procedure here
	@tahun int,
	@bulan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	/*Declare Table Variable*/
	DECLARE @dataSrc table(idMasterICD int, idJenisKelaminPasien tinyint, meninggal bit);

	/*Insert Data Into Variable*/
	INSERT INTO @dataSrc
			   (idMasterICD
			   ,idJenisKelaminPasien
			   ,meninggal)
		 SELECT b.idMasterICD
			   ,c.idJenisKelaminPasien
			   ,CASE
					 WHEN a.idStatusPasien IN(5,7,8,9)
						  THEN 1
					 ELSE 0
				 END AS meninggal
		   FROM dbo.transaksiPendaftaranPasien a
			    INNER JOIN dbo.transaksiDiagnosaPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
					INNER JOIN dbo.masterICD ba ON b.idMasterICD = ba.idMasterICD
					INNER JOIN consGolonganSebabPenyakit bb ON ba.idGolonganSebabPenyakit = bb.idGolonganSebabPenyakit AND bb.penyebab = 0
			    INNER JOIN dbo.masterPasien c ON a.idPasien = c.idPasien
		  WHERE YEAR(a.tglDaftarPasien) = @tahun AND MONTH(a.tglDaftarPasien) = @bulan AND a.idJenisPerawatan = 1/*RaNap*/;

	SELECT a.ICD AS kodeIcd, a.diagnosa, b.jmlL, c.jmlP, d.jmlHidup, e.jmlMati
	  FROM dbo.masterICD a
		   OUTER APPLY (SELECT COUNT(*) AS jmlL
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD AND xa.idJenisKelaminPasien = 1) b
		   OUTER APPLY (SELECT COUNT(*) AS jmlP
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD AND xa.idJenisKelaminPasien = 2) c
		   OUTER APPLY (SELECT COUNT(*) AS jmlHidup
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD AND xa.meninggal = 0) d
		   OUTER APPLY (SELECT COUNT(*) AS jmlMati
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD AND xa.meninggal = 1) e
		   CROSS APPLY (SELECT DISTINCT idMasterICD FROM @dataSrc xa WHERE xa.idMasterICD = a.idMasterICD) f
  ORDER BY d.jmlHidup DESC, e.jmlMati DESC
END