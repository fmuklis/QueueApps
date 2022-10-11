-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienIGDBatalBilling]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiBillingHeader Where idJenisBilling = 5/*Billing IGD*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Null)
		Begin
			/*Respon*/
			Select 'Gagal!: Billing Tagihan Gawat Daruat Telah Dibayar, Tidak Dapat Dibatalkan' As respon, 0 As responCode; 
		End
	Else 
		Begin Try
			/*Tran Begin*/
			Begin Tran;
			/*DELETE Hapus Billing Tagihan Rawat Jalan Yang Belom Dibayar*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idJenisBilling = 5/*Billing IGD*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Null;

			/*UPDATE Mengembalikan Status Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 3/*Dalam Perawatan Rawat Gawat Darurat*/
				  ,idStatusPasien = NULL
				  ,tglKeluarPasien = NULL
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Commit Begin*/
			Commit Tran;
			
			/*Respon*/
			Select 'Billing Tagihan Gawat Darurat Berhasil Dibatalkan, Pasien Kembali Dirawat' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Rollback Begin*/
			Rollback Tran;
			
			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END