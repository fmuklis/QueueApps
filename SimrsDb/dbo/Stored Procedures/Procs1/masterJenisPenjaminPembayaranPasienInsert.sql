CREATE PROCEDURE [dbo].[masterJenisPenjaminPembayaranPasienInsert]

  	@namaJenisPenjaminPembayaranPasien nvarchar(50)

As
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (select 1 from [masterJenisPenjaminPembayaranPasien] where [namaJenisPenjaminPembayaranPasien] = @namaJenisPenjaminPembayaranPasien)
	BEGIN
	INSERT INTO [dbo].[masterJenisPenjaminPembayaranPasien]
           ([namaJenisPenjaminPembayaranPasien])
     VALUES
           (@namaJenisPenjaminPembayaranPasien)
	select 'Data Berhasil Disimpan' as respon, 1 as responCode;
	END
	ELSE
	BEGIN
	select 'Maaf Penjamin Sudah Ada' as respon, 0 as responCode;
	END
END