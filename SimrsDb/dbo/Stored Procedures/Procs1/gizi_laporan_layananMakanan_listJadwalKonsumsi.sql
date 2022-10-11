-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gizi_laporan_layananMakanan_listJadwalKonsumsi]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT idJadwalKonsumsi, CONCAT(jadwalKonsumsi, ' - ', LEFT(jamKonnsumsi, 5)) AS jadwalKonsumsi
	  FROM dbo.constKonsumsiJadwal
  ORDER BY idJadwalKonsumsi
END