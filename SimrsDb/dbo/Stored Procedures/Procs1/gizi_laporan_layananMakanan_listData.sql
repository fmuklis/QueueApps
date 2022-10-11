-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gizi_laporan_layananMakanan_listData]
	-- Add the parameters for the stored procedure here
	@tanggalKonsumsi date,
	@idJadwalKonsumsi tinyint,
	@idRuangan int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make variable*/
	DECLARE @sql nvarchar(max)
		   ,@paramsDefinition nvarchar(max) = '@tanggalKonsumsiRef date, @idJadwalKonsumsiRef tinyint, @idRuanganRef int'
		   ,@filter nvarchar(max) = IIF(ISNULL(@idRuangan, 0) = 0, '', 'AND db.idRuangan = @idRuanganRef');


	SET @sql = '
		SELECT CONCAT(c.jadwalKonsumsi, '' - '', LEFT(c.jamKonnsumsi, 5)) AS jadwalKonsumsi, a.tanggalKonsumsi, a.keteranganDiet, a.jenisDiet
			  ,ba.noRM, ba.namaPasien, ba.namaJenisKelamin, ba.tglLahirPasien, ba.umur, e.diagnosa AS diagnosaAwal, bb.penjamin
			  ,dc.namaRuangan, CONCAT(db.namaRuanganRawatInap ,''/ Bed '', da.noTempatTidur) AS kamarInap, bd.NamaOperator
		  FROM dbo.layananGiziPasien a
			   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendafaranPasien = b.idPendaftaranPasien
					OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
					OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
					INNER JOIN dbo.masterOperator bd ON b.idDokter = bd.idOperator
			   INNER JOIN dbo.constKonsumsiJadwal c ON a.idJadwalKonsumsi = c.idJadwalKonsumsi
			   INNER JOIN dbo.transaksiPendaftaranPasienDetail d ON a.idPendafaranPasien = d.idPendaftaranPasien And d.aktif = 1/*true*/
					INNER JOIN dbo.masterRuanganTempatTidur da ON d.idTempatTidur = da.idTempatTidur
					INNER JOIN dbo.masterRuanganRawatInap db ON da.idRuanganRawatInap = db.idRuanganRawatInap
					INNER JOIN dbo.masterRuangan dc ON db.idRuangan = dc.idRuangan
			   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendafaranPasien) e
		 WHERE a.tanggalKonsumsi = @tanggalKonsumsiRef AND a.idJadwalKonsumsi = @idJadwalKonsumsiRef #dynamicHere#;';

	SET @sql = REPLACE(@sql, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @sql, @paramsDefinition, @tanggalKonsumsiRef = @tanggalKonsumsi, @idJadwalKonsumsiRef = @idJadwalKonsumsi, @idRuanganRef = @idRuangan;
END