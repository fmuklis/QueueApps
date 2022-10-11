CREATE PROCEDURE [dbo].[masterPasienCetakUpdate]
	@idPasien int
as
Begin
	set nocount on;
	Update masterPasien set jumlahCetak = jumlahCetak+1 where idPasien = @idPasien;
End