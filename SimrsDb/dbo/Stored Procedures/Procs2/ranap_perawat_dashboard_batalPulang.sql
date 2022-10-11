-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_dashboard_batalPulang]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idJenisBilling = 6/*Billing RaNap*/ AND idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar > 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, Billing Tagihan Rawat Inap Telah Dibayar' AS respon, 0 AS responCode; 
		END
	ELSE 
		BEGIN TRY
			/*Tran Begin*/
			Begin Tran;

			/*DELETE Hapus Billing Tagihan Rawat Inap Yang Belum Dibayar*/
			DELETE a
			  FROM dbo.transaksiBillingHeader a
				   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
						INNER JOIN dbo.masterJenisPenjaminPembayaranPasien ba ON b.idJenisPenjaminPembayaranPasien = ba.idJenisPenjaminPembayaranPasien
			 WHERE a.idJenisBilling = 6/*Billing RaNap*/ AND a.idPendaftaranPasien = @idPendaftaranPasien
				   AND idStatusBayar = 1/*Menunggu Pembayaran*/ AND ba.idJenisPenjaminInduk = 1/*UMUM*/;

			/*UPDATE Mengembalikan Status Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 5/*Dalam Perawatan Rawat Inap*/
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