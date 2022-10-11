CREATE PROCEDURE [dbo].[transaksiBillingBayarInsert]
	@idPendaftaran int,
	@idJenisBilling int,
	@idUserBayar int,
	@idJenisBayar int,
	@keterangan nvarchar(max)
as
Begin
	set nocount on;
	If @idJenisBilling != 0
		Begin
			UPDATE [dbo].[transaksiBillingHeader]
			   SET [tglBayar] = GETDATE()
				  ,[idUserBayar] = @idUserBayar
				  ,[idJenisBayar] = @idJenisBayar
				  ,[keterangan] = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaran And idJenisBilling = @idJenisBilling;

			If Exists(Select 1 From [dbo].[transaksiPendaftaranPasien] Where idPendaftaranPasien = @idPendaftaran And idStatusPendaftaran < 99)
				Begin
					UPDATE [dbo].[transaksiPendaftaranPasien]
					   SET idStatusPendaftaran = 99
					 WHERE idPendaftaranPasien = @idPendaftaran;
				End

 				select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End
	Else
		Begin
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End
end