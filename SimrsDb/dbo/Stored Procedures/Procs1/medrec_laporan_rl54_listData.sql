-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl54_listData]
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
	DECLARE @dataSrc table(idMasterICD int, idJenisKelaminPasien tinyint, baru bit);

	/*Insert Data Into Variable*/
	INSERT INTO @dataSrc
			   (idMasterICD
			   ,idJenisKelaminPasien
			   ,baru)
		 SELECT b.idMasterICD
			   ,c.idJenisKelaminPasien
			  ,CASE
					 WHEN EXISTS(SELECT TOP 1 1 FROM dbo.transaksiPendaftaranPasien xa WHERE xa.idPasien = a.idPasien AND xa.idPendaftaranPasien < a.idPendaftaranPasien)
						  THEN 1
					 ELSE 0
				 END AS baru
		   FROM dbo.transaksiPendaftaranPasien a
			    INNER JOIN dbo.transaksiDiagnosaPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
					INNER JOIN dbo.masterICD ba ON b.idMasterICD = ba.idMasterICD
					INNER JOIN consGolonganSebabPenyakit bb ON ba.idGolonganSebabPenyakit = bb.idGolonganSebabPenyakit AND bb.penyebab = 0
			    INNER JOIN dbo.masterPasien c ON a.idPasien = c.idPasien
		  WHERE YEAR(a.tglDaftarPasien) = @tahun AND MONTH(a.tglDaftarPasien) = @bulan AND a.idJenisPerawatan = 2/*RaJal*/;

	SELECT a.ICD AS kodeIcd, a.diagnosa, b.jmlL, c.jmlP, d.jmlKasusBaru, e.jmlKunjungan
	  FROM dbo.masterICD a
		   OUTER APPLY (SELECT COUNT(*) AS jmlL
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD AND xa.idJenisKelaminPasien = 1 AND xa.baru = 1) b
		   OUTER APPLY (SELECT COUNT(*) AS jmlP
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD AND xa.idJenisKelaminPasien = 2 AND xa.baru = 1) c
		   OUTER APPLY (SELECT COUNT(*) AS jmlKasusBaru
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD AND xa.baru = 1) d
		   OUTER APPLY (SELECT COUNT(*) AS jmlKunjungan
						  FROM @dataSrc xa
						 WHERE xa.idMasterICD = a.idMasterICD) e
		   CROSS APPLY (SELECT DISTINCT idMasterICD FROM @dataSrc xa WHERE xa.idMasterICD = a.idMasterICD) f
  ORDER BY e.jmlKunjungan DESC
END