-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienUpdateConvertBPJS]
	 @idPendaftaranPasien int
	 ,@idJenisPenjaminPembayaranPasien int
	 ,@idKelasPenjaminPembayaran int

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
			Begin Tran tranzRegPasienUpdateConvertBPJS9;
			DELETE dbo.transaksiBillingHeader Where idJenisBayar Is Null And idPendaftaranPasien = @idPendaftaranPasien;
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien
				  ,idKelasPenjaminPembayaran = @idKelasPenjaminPembayaran
			 WHERE idPendaftaranPasien = @idPendaftaranPasien
			Commit Tran tranzRegPasienUpdateConvertBPJS9;
			Select 'Berhasil, Penjamin Pembayaran Pasien Berubah Ke BPJS' As respon, 1 As responCode;
		End Try
		Begin Catch
			Rollback Tran tranzRegPasienUpdateConvertBPJS9;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch

END