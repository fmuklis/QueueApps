-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhpCetak_dataStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalStokOpname, d.tahun, d.bulan, a.kodeStokOpnameBhp AS kodeStokOpname, c.namaPetugasFarmasi AS petugas, b.namaRuangan AS lokasi
	  FROM dbo.farmasiStokOpname a
		   LEFT JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
		   LEFT JOIN dbo.farmasiMasterPetugas c ON a.idPetugas = c.idPetugasFarmasi
		   LEFT JOIN dbo.farmasiMasterPeriodeStokOpname d ON a.idPeriodeStokOpname = d.idPeriodeStokOpname
		   LEFT JOIN dbo.farmasiMasterStatusStokOpname e ON a.idStatusStokOpname = e.idStatusStokOpname
	 WHERE a.idStokOpname = @idStokOpname
END