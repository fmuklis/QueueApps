-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_responseTime_listData]
	-- Add the parameters for the stored procedure here
	@userIdSession int,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*MAke variable*/
	DECLARE @idJenisStok int;
	
	/*SET variable value*/
	SELECT @idJenisStok = b.idJenisStok
	  FROM dbo.masterUser a
		   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
	 WHERE a.idUser = @userIdSession;

	SELECT ba.namaJenisStok, a.tglResep, CAST(a.tanggalEntry AS time(0)) AS requestTime, dbo.format_medicalRecord(ca.kodePasien) AS noRM
		  ,COALESCE(cb.namaPasien, d.nama) AS namaPasien, a.noResep AS nomorResep, a.validationDate
		  ,DATEDIFF(MINUTE, CONCAT(a.tglResep, ' ', CAST(a.tanggalEntry AS time(0))), a.validationDate) AS waktuTunggu
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
				INNER JOIN dbo.farmasiMasterObatJenisStok ba ON b.idJenisStok = ba.idJenisStok
		   LEFT JOIN dbo.transaksiPendaftaranPasien c ON a.idPendaftaranPasien = c.idPendaftaranPasien
				LEFT JOIN dbo.masterPasien ca ON c.idPasien = ca.idPasien
				OUTER APPLY dbo.generate_namaPasien(ca.tglLahirPasien, a.tglResep, ca.idJenisKelaminPasien, ca.idStatusPerkawinanPasien, ca.namaLengkapPasien, ca.namaAyahPasien) cb
		   LEFT JOIN dbo.masterPasienLuar d ON a.idPasienLuar = d.idPasienLuar
	 WHERE a.idStatusResep = 3/*Resep Selesai Diproses*/ AND a.tglResep BETWEEN @periodeAwal AND @periodeAkhir AND b.idJenisStok = @idJenisStok AND a.idIMF IS NULL
  ORDER BY a.tglResep, requestTime, namaPasien
END