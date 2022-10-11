CREATE PROCEDURE [dbo].[masterJenisPendaftaranInsert]
	@namaJenisPendaftaran nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON
	IF not exists (select 1 from [dbo].[masterJenisPendaftaran] where [namaJenisPendaftaran] = @namaJenisPendaftaran)
	BEGIN	
	INSERT INTO [dbo].[masterJenisPendaftaran]
           ([namaJenisPendaftaran])
     VALUES
           (@namaJenisPendaftaran);
	SELECT 'Data Berhasil Disimpan' as respon, 1 as responCode;
	END
	ELSE
	BEGIN
	SELECT 'Maaf Data Sudah Ada' as respon, 0 as responCode;
	END
END