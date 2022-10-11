-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_listStokOpname]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idPeriodeStokOpname int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idStokOpname, a.tanggalStokOpname, d.tahun, d.bulan, a.kodeStokOpnameBhp AS kodeStokOpname, b.alias AS lokasiBhp, c.namaPetugasFarmasi AS petugas, 
			c.idPetugasFarmasi AS idPetugas, e.statusStokOpname, d.idPeriodeStokOpname, b.idRuangan, b.namaRuangan
		  ,CASE
				WHEN a.idStatusStokOpname = 1/*Proses Entry*/
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusStokOpname = 1/*Proses Entry*/
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusStokOpname = 1/*Proses Entry*/
					 THEN 1
				ELSE 0
			END AS btnDelete
		  ,CASE
				WHEN a.idStatusStokOpname = 5/*Valid / Selesai*/ AND CAST(a.tanggalModifikasi AS date) = CAST(GETDATE() AS date)
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
		  ,CASE
				WHEN a.idStatusStokOpname = 5/*Valid / Selesai*/
					 THEN 1
				ELSE 0
			END AS btnCetak
	  FROM dbo.farmasiStokOpname a
		   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
		   LEFT JOIN dbo.farmasiMasterPetugas c ON a.idPetugas = c.idPetugasFarmasi
		   LEFT JOIN dbo.farmasiMasterPeriodeStokOpname d ON a.idPeriodeStokOpname = d.idPeriodeStokOpname
		   LEFT JOIN dbo.farmasiMasterStatusStokOpname e ON a.idStatusStokOpname = e.idStatusStokOpname
	 WHERE a.idStatusStokOpname = 1/*Proses Entry*/ OR (CAST(a.tanggalModifikasi AS date) = CAST(GETDATE() AS date) 
		   OR (a.idStatusStokOpname = 5/*Valid / Selesai*/ AND a.idPeriodeStokOpname = @idPeriodeStokOpname AND a.idRuangan = @idRuangan))
  ORDER BY a.idStatusStokOpname
END