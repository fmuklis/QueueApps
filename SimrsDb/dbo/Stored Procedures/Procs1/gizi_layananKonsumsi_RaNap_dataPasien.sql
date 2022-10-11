-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gizi_layananKonsumsi_RaNap_dataPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int,
	@idJadwalKonsumsi int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH diet AS (
		SELECT a.idPasien, STRING_AGG(a.alergiPasien, ', ') AS alergiDiet
		  FROM dbo.masterPasienAlergi a
			   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
		 WHERE b.idPendaftaranPasien = @idPendaftaranPasien AND a.idJenisAlergi = 2/*alergi makanan*/
	  GROUP BY a.idPasien
	)
	SELECT a.idPendaftaranPasien, b.tglLahirPasien, b.noRM,  b.namaPasien, b.umur
		  ,c.namaRuangan, d.alergiDiet, e.jadwalKonsumsi
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien ) b
		   INNER JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan
		   LEFT JOIN diet d ON a.idPasien = d.idPasien
		   OUTER APPLY (SELECT jadwalKonsumsi FROM dbo.constKonsumsiJadwal WHERE idJadwalKonsumsi = @idJadwalKonsumsi) e
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END