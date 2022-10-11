CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addKabupaten]
@namaKabupaten nvarchar(50),
@idProvinsi int
AS
BEGIN
	SET NOCOUNT ON;
		if not exists (select 1 from [dbo].[masterKabupaten] where [namaKabupaten] = @namaKabupaten and [idProvinsi] = @idProvinsi)
		begin
			INSERT INTO [dbo].[masterKabupaten]
           ([namaKabupaten]
           ,[idProvinsi])
     VALUES
           (@namaKabupaten
           ,@idProvinsi)
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf Nama Kabupaten Sudah Ada' as respon, 0 as responCode;
		end
END