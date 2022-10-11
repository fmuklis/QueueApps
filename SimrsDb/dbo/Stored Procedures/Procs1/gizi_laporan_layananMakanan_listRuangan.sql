-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gizi_laporan_layananMakanan_listRuangan]
	-- Add the parameters for the stored procedure here
	@tanggalKonsumsi date,
	@idJadwalKonsumsi tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 'Semua' AS namaRuangan, 0 AS idRuangan
	 UNION ALL
	SELECT DISTINCT bb.namaRuangan, bb.idRuangan
	  FROM dbo.layananGiziPasien a
		   INNER JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				INNER JOIN dbo.masterRuanganRawatInap ba ON b.idRuanganRawatInap = ba.idRuanganRawatInap
				INNER JOIN dbo.masterRuangan bb ON ba.idRuangan = bb.idRuangan
	 WHERE a.tanggalKonsumsi = @tanggalKonsumsi And a.idJadwalKonsumsi = @idJadwalKonsumsi
END