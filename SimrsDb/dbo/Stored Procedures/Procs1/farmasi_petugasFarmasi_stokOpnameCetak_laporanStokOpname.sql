-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameCetak_laporanStokOpname]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idPeriodeStokOpname int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok tinyint = (SELECT idJenisStok FROM masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT e.namaJenisStok, a.kodeStokOpname, d.tahun, d.bulan, a.tanggalStokOpname, c.namaPetugasFarmasi AS petugas
			  ,bc.jenisStokOpname, bb.namaBarang, b.kodeBatch, b.tglExpired, b.hargaPokok, b.jumlahAwal, b.jumlahStokOpname, f.alias AS lokasi
		  FROM dbo.farmasiStokOpname a
			   INNER JOIN dbo.farmasiStokOpnameDetail b ON a.idStokOpname = b.idStokOpname
				   LEFT JOIN dbo.farmasiMasterObatDetail ba ON b.idObatDetail = ba.idObatDetail
				   OUTER APPLY dbo.getInfo_barangFarmasi(ba.idObatDosis) bb
				   LEFT JOIN dbo.farmasiMasterJenisStokOpname bc ON b.idJenisStokOpname = bc.idJenisStokOpname
			   LEFT JOIN dbo.farmasiMasterPetugas c ON a.idPetugas = c.idPetugasFarmasi
			   LEFT JOIN dbo.farmasiMasterPeriodeStokOpname d ON a.idPeriodeStokOpname = d.idPeriodeStokOpname
			   LEFT JOIN dbo.farmasiMasterObatJenisStok e ON a.idJenisStok = e.idJenisStok
			   LEFT JOIN dbo.masterRuangan f ON a.idRuangan = f.idRuangan
		 WHERE a.idPeriodeStokOpname = @idPeriodeStokOpname AND a.idJenisStok = @idJenisStok AND a.idStatusStokOpname = 5/*Valid / Selesai*/
	  ORDER BY d.tahun, d.bulan, a.tanggalStokOpname, c.namaPetugasFarmasi
END