-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl4a_listData]
	-- Add the parameters for the stored procedure here
	@tahun int,
	@penyebab bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*Declare Table Variable*/
	DECLARE @dataSrc table(idGolonganSebabPenyakit int, idJenisKelaminPasien tinyint, golUmur varchar(50), meninggal bit);

	/*Insert Data Into Variable*/
	INSERT INTO @dataSrc
			   (idGolonganSebabPenyakit
			   ,idJenisKelaminPasien
			   ,golUmur
			   ,meninggal)
		 SELECT ba.idGolonganSebabPenyakit, c.idJenisKelaminPasien
			   ,CASE
					 WHEN d.umur >= 65 AND d.satuanUmur = 'tahun'
						  THEN '>65Th'
					 WHEN d.umur >= 45 AND d.satuanUmur = 'tahun'
						  THEN '45-65Th'
					 WHEN d.umur >= 25 AND d.satuanUmur = 'tahun'
						  THEN '25-44Th'
					 WHEN d.umur >= 15 AND d.satuanUmur = 'tahun'
						  THEN '15-24Th'
					 WHEN d.umur >= 5 AND d.satuanUmur = 'tahun'
						  THEN '5-14Th'
					 WHEN d.umur >= 1 AND d.satuanUmur = 'tahun'
						  THEN '1-4Th'
					 WHEN d.umur >= 7 AND d.satuanUmur = 'hari'
						  THEN '7-28Hr'
					 WHEN d.umur >= 0 AND d.satuanUmur = 'hari'
						  THEN '0-6Hr'
					 ELSE '28hr-<1Th'
				 END AS golUmur		  
			  ,CASE
					 WHEN a.idStatusPasien IN(5,7,8,9)
						  THEN 1
					 ELSE 0
				 END AS meninggal
		   FROM dbo.transaksiPendaftaranPasien a
			    INNER JOIN dbo.transaksiDiagnosaPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
					INNER JOIN dbo.masterICD ba ON b.idMasterICD = ba.idMasterICD
					INNER JOIN dbo.consGolonganSebabPenyakit bb ON ba.idGolonganSebabPenyakit = bb.idGolonganSebabPenyakit
			    INNER JOIN dbo.masterPasien c ON a.idPasien = c.idPasien
			    OUTER APPLY dbo.calculator_umur(c.tglLahirPasien, a.tglDaftarPasien) d
		  WHERE a.idJenisPerawatan = 1/*RaNap*/ AND YEAR(a.tglDaftarPasien) = @tahun AND bb.penyebab = @penyebab;
	
	/*Select Data Report*/
	SELECT a.nomorDTD, a.nomorDaftarTerperinci, a.golonganSebabPenyakit, b.katA, c.katB, d.katC, e.katD, f.katE
		  ,g.katF, h.katG, i.katH, j.katI, k.katJ, l.katK, m.katL, n.katM, o.katN, p.katO, q.katP, r.katQ, s.katR
		  ,t.jmlL, u.jmlP, v.jmlHidup, w.jmlMati
	  FROM dbo.consGolonganSebabPenyakit a
		   OUTER APPLY (SELECT COUNT(*) AS katA
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '>65Th') b
		   OUTER APPLY (SELECT COUNT(*) AS katB
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '>65Th') c
		   OUTER APPLY (SELECT COUNT(*) AS katC
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '45-65Th') d
		   OUTER APPLY (SELECT COUNT(*) AS katD
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '45-65Th') e
		   OUTER APPLY (SELECT COUNT(*) AS katE
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '25-44Th') f
		   OUTER APPLY (SELECT COUNT(*) AS katF
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '25-44Th') g
		   OUTER APPLY (SELECT COUNT(*) AS katG
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '15-24Th') h
		   OUTER APPLY (SELECT COUNT(*) AS katH
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '15-24Th') i
		   OUTER APPLY (SELECT COUNT(*) AS katI
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '5-14Th') j
		   OUTER APPLY (SELECT COUNT(*) AS katJ
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '5-14Th') k
		   OUTER APPLY (SELECT COUNT(*) AS katK
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '1-4Th') l
		   OUTER APPLY (SELECT COUNT(*) AS katL
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '1-4Th') m
		   OUTER APPLY (SELECT COUNT(*) AS katM
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '28hr-<1Th') n
		   OUTER APPLY (SELECT COUNT(*) AS katN
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '28hr-<1Th') o
		   OUTER APPLY (SELECT COUNT(*) AS katO
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '7-28Hr') p
		   OUTER APPLY (SELECT COUNT(*) AS katP
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '7-28Hr') q
		   OUTER APPLY (SELECT COUNT(*) AS katQ
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 1 AND xa.golUmur = '0-6Hr') r
		   OUTER APPLY (SELECT COUNT(*) AS katR
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit
							   AND xa.idJenisKelaminPasien = 2 AND xa.golUmur = '0-6Hr') s
		   OUTER APPLY (SELECT COUNT(*) AS jmlL
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit AND xa.idJenisKelaminPasien = 1) t
		   OUTER APPLY (SELECT COUNT(*) AS jmlP
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit AND xa.idJenisKelaminPasien = 2) u
		   OUTER APPLY (SELECT COUNT(*) AS jmlHidup
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit AND xa.meninggal = 0) v
		   OUTER APPLY (SELECT COUNT(*) AS jmlMati
						  FROM @dataSrc xa
						 WHERE xa.idGolonganSebabPenyakit = a.idGolonganSebabPenyakit AND xa.meninggal = 1) w
     WHERE a.penyebab = @penyebab
END