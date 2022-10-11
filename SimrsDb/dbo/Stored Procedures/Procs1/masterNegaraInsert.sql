CREATE PROCEDURE [dbo].[masterNegaraInsert]
	@namaNegara nvarchar(50)
as
Begin
	set nocount on;
		If not exists(Select 1 from masterNegara where namaNegara = @namaNegara)
		Begin
		INSERT INTO [dbo].masterNegara
           ([namaNegara])
		VALUES
           (@namaNegara);
		   Select 'Data berhasil disimpan' as respon, 1 as responCode;
		End
		else
		Begin
			Select 'Maaf Nama Negara Sudah Ada' as respon, 0 as responCode;
		End
End