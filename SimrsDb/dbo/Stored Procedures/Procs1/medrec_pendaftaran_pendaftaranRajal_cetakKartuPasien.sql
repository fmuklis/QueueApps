CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_cetakKartuPasien]
	@idPasien int
as
Begin
	set nocount on;
	Update masterPasien set cetakKartu = 1 where idPasien = @idPasien;
	Select 'Kartu Berhasil Dicetak' as respon, 1 as responCode;
End