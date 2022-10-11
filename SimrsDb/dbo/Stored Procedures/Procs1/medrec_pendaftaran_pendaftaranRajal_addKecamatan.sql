CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addKecamatan]
@namaKecamatan nvarchar(50),
@idKabupaten int
AS
BEGIN
	SET NOCOUNT ON;
		if not exists (select 1 from [dbo].[masterKecamatan] where [namaKecamatan] = @namaKecamatan and idKabupaten = @idKabupaten)
		begin
			INSERT INTO [dbo].[masterKecamatan]
           ([namaKecamatan]
           ,[idKabupaten])
     VALUES
           (@namaKecamatan
           ,@idKabupaten)
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf Nama Kecamatan Sudah Ada' as respon, 0 as responCode;
		end
END