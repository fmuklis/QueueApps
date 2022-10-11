-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_addNamaBarang]
	-- Add the parameters for the stored procedure here
	@idGolonganObat int,
	@idKategoriBarang tinyint,
	@idJenisObat int,
	@namaObat nvarchar(225),
	@idSatuanObat int,
	@idUserEntry int,
	@stokMinimalGudang int,
	@stokMinimalApotek int,
	@jumlahHariPeringatanKadaluarsa int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObat WHERE namaObat = @namaObat AND idSatuanObat = @idSatuanObat)
		BEGIN
			Select 'Tidak Dapat Disimpan '+ @namaObat +' Sudah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiMasterObat]
					   ([idGolonganObat]
					   ,[idKategoriBarang]
					   ,[idJenisObat]
					   ,[namaObat]
					   ,[idSatuanObat]
					   ,[stokMinimalGudang]
					   ,[stokMinimalApotik]
					   ,[jumlahHariPeringatanKadaluarsa]
					   ,[idUserEntry])
				 VALUES
					   (@idGolonganObat
					   ,@idKategoriBarang
					   ,@idJenisObat
					   ,@namaObat
					   ,@idSatuanObat
					   ,@stokMinimalGudang
					   ,@stokMinimalApotek
					   ,@jumlahHariPeringatanKadaluarsa
					   ,@idUserEntry);
			
			Select 'Data Nama Barang Farmasi Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END