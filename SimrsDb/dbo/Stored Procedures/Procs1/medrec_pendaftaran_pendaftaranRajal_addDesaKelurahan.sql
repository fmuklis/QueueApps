CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addDesaKelurahan]
	@namaDesaKelurahan nvarchar(50),
	@idKecamatan int
AS
BEGIN
	SET NOCOUNT ON;
		if  not exists (select 1 from [dbo].[masterDesaKelurahan] where [namaDesaKelurahan] = @namaDesaKelurahan and [idKecamatan] = @idKecamatan)
		begin
			INSERT INTO [dbo].[masterDesaKelurahan]
           ([namaDesaKelurahan]
           ,[idKecamatan])
     VALUES
           (@namaDesaKelurahan
           ,@idKecamatan);
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf Data Desa / Kelurahan Sudah Ada' as respon, 0 as responCode;
		end
END