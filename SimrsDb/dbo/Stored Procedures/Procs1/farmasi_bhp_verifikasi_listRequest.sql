-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_verifikasi_listRequest]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMutasi, a.tanggalOrder, a.nomorOrder, c.namaRuangan AS ruanganAsal, a.tanggalAprove, a.kodeMutasi, d.statusMutasi
		  ,CASE
				WHEN a.idStatusMutasi IN(2,3)/*Divalidasi, Verifikasi Request*/
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusMutasi = 3/*Verifikasi Request*/
					 THEN 1
				ELSE 0
			END AS btnBatalVerifikasi
		  ,CASE
				WHEN a.idStatusMutasi = 4/*Selesai*/
					 THEN 1
				ELSE 0
			END AS btnCetakBuktiPenerimaan
		  ,CASE
				WHEN a.idStatusMutasi = 4/*Selesai*/ AND CAST(a.tanggalModifikasi AS date) = CAST(GETDATE() AS date)
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi			
	  FROM dbo.farmasiMutasi a
		   INNER JOIN dbo.masterRuangan b ON a.idJenisStokAsal = b.idJenisStok
		   LEFT JOIN dbo.masterRuangan c On a.idRuangan = c.idRuangan		
		   LEFT JOIN dbo.farmasiMasterStatusMutasi d On a.idStatusMutasi = d.idStatusMutasi		  
	 WHERE a.idJenisMutasi = 2/*Mutasi BHP*/ AND b.idRuangan = @idRuangan
		   AND (a.idStatusMutasi = 2 OR (a.idStatusMutasi IN(3,4) AND a.tanggalOrder BETWEEN @periodeAwal AND @periodeAkhir))
  ORDER BY a.tanggalOrder DESC;
END