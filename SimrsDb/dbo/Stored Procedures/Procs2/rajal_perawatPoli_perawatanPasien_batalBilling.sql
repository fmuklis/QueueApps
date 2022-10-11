-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[rajal_perawatPoli_perawatanPasien_batalBilling]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiBillingHeader Where idJenisBilling = 1/*Billing Rawat Jalan*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Null)
		Begin
			/*Respon*/
			Select 'Gagal!: Billing Tagihan Rawat Jalan Telah Dibayar, Tidak Dapat Dibatalkan' As respon, 0 As responCode; 
		End
	Else 
		Begin Try
			/*Tran Begin*/
			Begin Tran;

			/*DELETE Hapus Billing Tagihan Rawat Jalan Yang Belom Dibayar*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idJenisBilling = 1/*Billing Rawat Jalan*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Null;

			/*UPDATE Mengembalikan Status Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 2/*Dalam Perawatan Rawat Jalan*/
				  ,idStatusPasien = NULL
				  ,tglKeluarPasien = NULL
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Commit Begin*/
			Commit Tran;
			
			/*Respon*/
			Select 'Billing Tagihan Rawat Jalan Berhasil Dibatalkan, Pasien Kembali Dirawat' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Rollback Begin*/
			Rollback Tran;
			
			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END