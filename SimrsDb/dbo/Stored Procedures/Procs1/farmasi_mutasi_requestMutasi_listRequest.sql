-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_mutasi_requestMutasi_listRequest]
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
	SELECT a.idMutasi, a.idJenisStokAsal, a.tanggalOrder, a.nomorOrder, c.namaJenisStok AS tujuanOrder, b.statusMutasi, a.keterangan
		  ,CASE
				WHEN a.idStatusMutasi = 1
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusMutasi = 1
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusMutasi = 1
					 THEN 1
				ELSE 0
			END AS btnHapus
		  ,CASE
				WHEN a.idStatusMutasi = 2
					 THEN 1
				ELSE 0
			END AS btnCetakOrder
		  ,CASE
				WHEN a.idStatusMutasi = 2
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi			
	  FROM dbo.farmasiMutasi a
		   LEFT JOIN dbo.farmasiMasterStatusMutasi b On a.idStatusMutasi = b.idStatusMutasi		  
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c On a.idJenisStokAsal = c.idJenisStok		
	 WHERE a.idJenisMutasi = 1/*Mutasi Barang Farmasi*/ AND a.idJenisStokTujuan = @idJenisStokTujuan
		   AND (a.idStatusMutasi IN(1,2) OR (a.idStatusMutasi IN(3,4) AND a.tanggalOrder BETWEEN @periodeAwal AND @periodeAkhir))
  ORDER BY a.tanggalOrder DESC;
END