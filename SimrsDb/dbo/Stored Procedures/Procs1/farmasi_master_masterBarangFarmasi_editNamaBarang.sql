-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_editNamaBarang] 
	-- Add the parameters for the stored procedure here
	@idObat int,
	@idKategoriBarang int,
	@namaObat nvarchar(225),
	@idJenisObat int,
	@idSatuanObat int,
	@idUserEntry int,
	@stokMinimalGudang int,
	@stokMinimalApotek int,
	@jumlahHariPeringatanKadaluarsa int,
	@idGolonganObat int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(Select 1 From dbo.farmasiMasterObat WHERE idObat <> @idObat AND idSatuanObat = @idSatuanObat AND namaObat = @namaObat)
		BEGIN
			Select 'Tidak Ddapat Diedit, Nama Barang Farmasi Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		Begin
			UPDATE dbo.farmasiMasterObat
			   SET idGolonganObat = @idGolonganObat
				  ,idKategoriBarang = @idKategoriBarang
				  ,namaObat = @namaObat
				  ,idJenisObat = @idJenisObat
				  ,idSatuanObat = @idSatuanObat
				  ,idUserEntry = @idUserEntry			
				  ,stokMinimalGudang = @stokMinimalGudang
				  ,stokMinimalApotik = @stokMinimalApotek
				  ,jumlahHariPeringatanKadaluarsa = @jumlahHariPeringatanKadaluarsa
			 WHERE idObat = @idObat;

			Select 'Data Nama Barang Farmasi Berhasil Diupdate' AS respon, 1 AS responCode;
		End
END