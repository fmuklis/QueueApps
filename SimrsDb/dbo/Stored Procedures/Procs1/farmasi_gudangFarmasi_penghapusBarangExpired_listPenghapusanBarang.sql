-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_listPenghapusanBarang]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT a.idPenghapusanStok, a.tanggalPenghapusan, b.namaPetugasFarmasi AS pemohon, b.idPetugasFarmasi AS idPemohon, c.statusPenghapusan AS status
		  ,CASE
			   WHEN a.idStatusPenghapusan = 1 /*Entry Penghapusan*/
				THEN 1
			ELSE 0
		END AS btnDetail
		,CASE
			WHEN a.idStatusPenghapusan = 1 /*Entry Penghapusan*/
				THEN 1
			ELSE 0
		END AS btnEdit
		,CASE
			WHEN a.idStatusPenghapusan = 1 /*Entry Penghapusan*/
				THEN 1
			ELSE 0
		END AS btnDelete
		,CASE
			WHEN a.idStatusPenghapusan = 5 /*Valid*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)
				THEN 1
			ELSE 0
		END AS btnBatalValidasi
		,CASE
			WHEN a.idStatusPenghapusan = 5 /*Valid*/
				THEN 1
			ELSE 0
		END AS btnCetak
	FROM dbo.farmasiPenghapusanStok a
		 LEFT JOIN dbo.farmasiMasterPetugas b ON a.idPetugas = b.idPetugasFarmasi 
		 LEFT JOIN dbo.farmasiMasterStatusPenghapusan c ON a.idStatusPenghapusan = c.idStatusPenghapusan
   WHERE a.idStatusPenghapusan = 1 /*Proses Entry*/ OR (a.idStatusPenghapusan = 5 AND (a.tanggalPenghapusan BETWEEN @periodeAwal AND @periodeAkhir OR a.tanggalModifikasi = CAST(GETDATE() AS date)))
ORDER BY a.tanggalPenghapusan
END