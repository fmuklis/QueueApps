﻿-- =============================================
-- Author:		Komar
-- Create date: 30/11/2021
-- Description: list kamar kosong berdasarkan idPendaftaran untuk aplicare
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_aplicare_kamarKosongById]
	@idPendaftaranPasien int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	WITH bed AS (
		SELECT b.idTempatTidur 
		FROM dbo.transaksiPendaftaranPasienDetail b
			  INNER JOIN dbo.transaksiPendaftaranPasien ba ON b.idPendaftaranPasien = ba.idPendaftaranPasien AND ba.idStatusPendaftaran IN (5,6) /*ranap*/
		WHERE b.aktif = 1 /*true*/
	)
	,bedPasien AS (
		SELECT ab.alias, ac.kodeKelas
		FROM dbo.masterRuanganTempatTidur a
				INNER JOIN dbo.masterRuanganRawatInap aa ON a.idRuanganRawatInap = aa.idRuanganRawatInap
				INNER JOIN dbo.masterRuangan ab ON aa.idRuangan = ab.idRuangan
				INNER JOIN dbo.masterKelas ac ON aa.idKelas = ac.idKelas
			INNER JOIN dbo.transaksiPendaftaranPasienDetail b ON a.idTempatTidur = b.idTempatTidur
		WHERE b.idPendaftaranPasien = @idPendaftaranPasien
	)


	SELECT ac.kodeKelas as kodekelas, ab.alias AS koderuang, ab.namaRuangan as namaruang
			,COUNT(a.idTempatTidur) AS kapasitas
			,COUNT(IIF(b.idTempatTidur IS NULL, 1, NULL)) AS tersedia
			,COUNT(IIF(b.idTempatTidur IS NULL AND aa.idJenisKelamin = 1, 1, NULL)) AS tersediapria
			,COUNT(IIF(b.idTempatTidur IS NULL AND aa.idJenisKelamin = 2, 1, NULL)) AS tersediawanita
			,COUNT(IIF(b.idTempatTidur IS NULL AND aa.idJenisKelamin IS NULL, 1, NULL)) AS tersediapriawanita
	  FROM dbo.masterRuanganTempatTidur a
			  INNER JOIN dbo.masterRuanganRawatInap aa ON a.idRuanganRawatInap = aa.idRuanganRawatInap
			  INNER JOIN dbo.masterRuangan ab ON aa.idRuangan = ab.idRuangan
			  INNER JOIN dbo.masterKelas ac ON aa.idKelas = ac.idKelas
			  INNER JOIN bedPasien ad on ab.alias = ad.alias AND ac.kodeKelas = ad.kodeKelas
			LEFT JOIN bed b ON a.idTempatTidur = b.idTempatTidur
	WHERE ab.aktif = 1 /*true*/ AND a.flagMasihDigunakan = 1 /*true*/
	GROUP BY ab.alias, ac.kodeKelas, ab.namaRuangan



END