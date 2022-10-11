-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudang_listRequest]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStokAsal tinyint = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idRetur, a.tanggalRetur, c.namaJenisStok AS asalRetur, d.namaJenisStok AS tujuanRetur, b.statusRetur, a.keterangan
		  ,CASE
				WHEN a.idStatusRetur = 1/*Proses Entry Request*/
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusRetur = 1/*Proses Entry Request*/
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusRetur = 1/*Proses Entry Request*/
					 THEN 1
				ELSE 0
			END AS btnHapus
		  ,CASE
				WHEN a.idStatusRetur >= 5/*Request Valid*/
					 THEN 1
				ELSE 0
			END AS btnCetakRequest
		  ,CASE
				WHEN a.idStatusRetur = 5/*Request Valid*/
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi			
	  FROM dbo.farmasiRetur a
		   LEFT JOIN dbo.farmasiMasterStatusRetur b On a.idStatusRetur = b.idStatusRetur	  
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c On a.idJenisStokTujuan = c.idJenisStok	
		   LEFT JOIN dbo.farmasiMasterObatJenisStok d On a.idJenisStokTujuan = d.idJenisStok
	 WHERE a.idJenisRetur = 2/*Retur Kegudang*/ AND a.idJenisStokAsal = @idJenisStokAsal
		   AND (a.idStatusRetur IN(1,5) OR (a.idStatusRetur = 10 AND a.tanggalRetur BETWEEN @periodeAwal AND @periodeAkhir))
  ORDER BY a.tanggalRetur DESC;
END