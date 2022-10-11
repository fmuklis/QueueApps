-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returKegudang_listRequest]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStokTujuan tinyint = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idRetur, a.tanggalRetur, a.kodeRetur, c.namaJenisStok AS asalRetur, d.namaJenisStok AS tujuanRetur, b.statusRetur, a.keterangan
		  ,CASE
				WHEN a.idStatusRetur = 5/*Request Divalidasi*/
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusRetur = 10/*Request Diterima*/
					 THEN 1
				ELSE 0
			END AS btnCetak
		  ,CASE
				WHEN a.idStatusRetur = 10/*Request Diterima*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)
					 THEN 1
				ELSE 0
			END AS btnBatalDiterima		
	  FROM dbo.farmasiRetur a
		   LEFT JOIN dbo.farmasiMasterStatusRetur b On a.idStatusRetur = b.idStatusRetur	  
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c On a.idJenisStokAsal = c.idJenisStok
		   LEFT JOIN dbo.farmasiMasterObatJenisStok d On a.idJenisStokTujuan = d.idJenisStok	
	 WHERE a.idJenisRetur = 2/*Retur Kegudang*/ AND a.idJenisStokTujuan = @idJenisStokTujuan
		   AND (a.idStatusRetur = 5 OR (a.idStatusRetur = 10 AND (a.tanggalRetur BETWEEN @periodeAwal AND @periodeAkhir OR a.tanggalModifikasi = CAST(GETDATE() AS date))))
  ORDER BY a.tanggalRetur DESC;
END