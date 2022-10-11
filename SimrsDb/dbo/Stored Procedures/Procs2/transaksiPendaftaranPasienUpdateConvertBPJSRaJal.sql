-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienUpdateConvertBPJSRaJal]
	 @idPendaftaranPasien int
	 ,@idJenisPenjaminPembayaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idStatusPendaftaran > = 99 And idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Pasien '+ b.namaStatusPendaftaran As respon, 0 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin Try
			Begin Tran;
			DELETE dbo.transaksiBillingHeader Where idJenisBayar Is Null And idPendaftaranPasien = @idPendaftaranPasien;

			UPDATE dbo.transaksiPendaftaranPasien
			   SET idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien
			 WHERE idPendaftaranPasien = @idPendaftaranPasien
			Commit Tran;

			Select 'Berhasil, Penjamin Pembayaran Pasien Berubah Ke BPJS' As respon, 1 As responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch

END