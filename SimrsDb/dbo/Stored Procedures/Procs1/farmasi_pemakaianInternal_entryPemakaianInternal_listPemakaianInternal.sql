-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternal_listPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPemakaianInternal, a.tanggalPermintaan, a.kodePemakaianInternal, b.namaBagian AS unit, a.pemohon, c.statusPemakaianInternal
		  ,CASE
				WHEN a.idStatusPemakaianInternal = 1/*Proses Entry*/
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusPemakaianInternal = 1/*Proses Entry*/
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusPemakaianInternal = 1/*Proses Entry*/
					 THEN 1
				ELSE 0
			END AS btnDelete
		  ,CASE
				WHEN a.idStatusPemakaianInternal = 5/*Valid / Selesai*/ AND CAST(a.tanggalModifikasi AS date) = CAST(GETDATE() AS date)
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
		  ,CASE
				WHEN a.idStatusPemakaianInternal = 5/*Valid / Selesai*/
					 THEN 1
				ELSE 0
			END AS btnCetak
	  FROM dbo.farmasiPemakaianInternal a
		   LEFT JOIN dbo.farmasiPemakaianInternalBagian b ON a.idBagian = b.idBagian
		   LEFT JOIN dbo.farmasiMasterStatusPemakaianInternal c ON a.idStatusPemakaianInternal = c.idStatusPemakaianInternal
		   INNER JOIN dbo.masterRuangan d ON a.idJenisStok = d.idJenisStok AND d.idRuangan = @idRuangan
	 WHERE a.idStatusPemakaianInternal = 1/*Proses Entry*/ OR (a.idStatusPemakaianInternal = 5/*Valid / Selesai*/
		   AND (tanggalPermintaan BETWEEN @periodeAwal AND @periodeAkhir) OR CAST(a.tanggalModifikasi AS date) = CAST(GETDATE() AS date))
  ORDER BY a.idStatusPemakaianInternal, a.tanggalPermintaan, b.namaBagian
END