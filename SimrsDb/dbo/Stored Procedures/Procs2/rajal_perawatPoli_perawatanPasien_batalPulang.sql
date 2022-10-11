-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawatPoli_perawatanPasien_batalPulang]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiBillingHeader Where idJenisBilling = 5/*Billing IGD*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Not Null)
		Begin
			/*Respon*/
			Select 'Billing Tagihan Poli Rawat Jalan Telah Dibayar, Tidak Dapat Dibatalkan' As respon, 0 As responCode; 
		End
	Else 
		Begin Try
			/*Tran Begin*/
			Begin Tran;

			/*DELETE Hapus Billing Tagihan Gawat Darurat Yang Belum Dibayar*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idJenisBilling = 2/*Billing RAJAL*/ And idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Null;

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
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch
END