CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addPekerjaan]
	@namaPekerjaan nvarchar(50)
as
Begin
	set nocount on;
		If not exists(Select 1 from [dbo].[masterPekerjaan] where [namaPekerjaan] = @namaPekerjaan)
		Begin
		INSERT INTO [dbo].[masterPekerjaan]
           ([namaPekerjaan])
		VALUES
           (@namaPekerjaan);
		   Select 'Data berhasil disimpan' as respon, 1 as responCode;
		End
		else
		Begin
			Select 'Maaf Nama Pekerjaan Sudah Ada' as respon, 0 as responCode;
		End
End