CREATE PROCEDURE [dbo].[masterTaripPeriodeInsert]
			@tglMulaiBerlaku date
           ,@nomorDokumen nvarchar(50)
           ,@keterangan nvarchar(max)
as
Begin
set nocount on;
if not exists(Select 1 from masterTaripPeriode where nomorDokumen = @nomorDokumen)
Begin
INSERT INTO [dbo].[masterTaripPeriode]
           ([tglMulaiBerlaku]
           ,[nomorDokumen]
           ,[keterangan])
     VALUES
           (@tglMulaiBerlaku
           ,@nomorDokumen
           ,@keterangan)
			Select 'Data berhasil disimpan' as respon;
End
End