-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternalCetak_dataPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@idPemakaianInternal bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalPermintaan, a.kodePemakaianInternal, b.namaBagian AS unit, a.pemohon, c.namaPetugasFarmasi AS petugas
	  FROM dbo.farmasiPemakaianInternal a
		   LEFT JOIN dbo.farmasiPemakaianInternalBagian b ON a.idBagian = b.idBagian
		   LEFT JOIN dbo.farmasiMasterPetugas c ON a.idPetugas = c.idPetugasFarmasi
	 WHERE a.idPemakaianInternal = @idPemakaianInternal
END