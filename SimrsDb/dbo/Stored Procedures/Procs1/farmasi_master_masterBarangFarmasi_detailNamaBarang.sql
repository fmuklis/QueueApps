-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_detailNamaBarang]
	-- Add the parameters for the stored procedure here
	@idObat int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObat, a.idKategoriBarang, b.kategoriBarang, namaObat, a.idJenisObat, c.namaJenisObat
		  ,a.idSatuanObat, d.namaSatuanObat, stokMinimalGudang, stokMinimalApotik, jumlahHariPeringatanKadaluarsa
		  ,e.idGolonganObat, e.namaGolonganObat
	  FROM dbo.farmasiMasterObat a
		   LEFT JOIN dbo.farmasiMasterObatKategori b ON a.idKategoriBarang = b.idKategoriBarang
		   LEFT JOIN dbo.farmasiMasterObatJenis c ON a.idJenisObat = c.idJenisObat
		   LEFT JOIN dbo.farmasiMasterSatuanObat d ON a.idSatuanObat = d.idSatuanObat
		   LEFT JOIN dbo.farmasiMasterObatGolongan e ON a.idGolonganObat = e.idGolonganObat
	 WHERE a.idObat = @idObat
END