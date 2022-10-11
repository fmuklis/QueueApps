CREATE PROCEDURE [dbo].[masterJenisPenjaminInsert]
	@namaJenisPenjaminPembayaranPasien nvarchar(50)
as
Begin
	set nocount on;
if not exists(Select 1 from masterJenisPenjaminPembayaranPasien a where a.namaJenisPenjaminPembayaranPasien = @namaJenisPenjaminPembayaranPasien)
Begin
INSERT INTO [dbo].[masterJenisPenjaminPembayaranPasien]
           ([namaJenisPenjaminPembayaranPasien])
     VALUES
           (@namaJenisPenjaminPembayaranPasien);
		   Select 'Data berhasil disimpan' as respon,1 as responCode;
End
else
Begin
	Select 'Data sudah' as respon,0 as responCode;
End
End