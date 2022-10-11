-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienRawatJalanBatalPulang]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiBillingHeader Where idJenisBilling = 1/*Billing Rawat Jalan*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Not Null)
		Begin
			/*Respon*/
			Select 'Gagal!: Billing Tagihan Rawat Jalan Telah Dibayar, Tidak Dapat Dibatalkan' As respon, 0 As responCode; 
		End
	Else 
		Begin Try
			/*Tran Begin*/
			Begin Tran;

			/*DELETE Hapus Billing Tagihan Rawat Jalan Yang Belum Dibayar*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idJenisBilling = 1/*Billing Rawat Jalan*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Null;

			/*UPDATE Mengembalikan Status Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 2/*Dalam Perawatan Rawat Jalan*/
				  ,idStatusPasien = NULL
				  ,tglKeluarPasien = NULL
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Tran Commit*/
			Commit Tran;

			/*Respon*/
			Select 'Pasien Batal Dipulangkan, Pasien Kembali Dirawat' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Tran Rollback*/
			Rollback Tran;

			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END