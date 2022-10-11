-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_dashboard_batalBilling]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idJenisBilling = 5/*Bill IGD*/
					 AND idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar <> 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, Billing Tagihan Gawat Daruat Telah Dibayar' AS respon, 0 AS responCode; 
		END
	ELSE 
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Hapus Billing Tagihan IGD Yang Belum Dibayar*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idJenisBilling = 5/*Billing IGD*/ AND idPendaftaranPasien = @idPendaftaranPasien;

			/*Mengembalikan Status Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 3/*Dalam Perawatan Rawat Darurat*/
				  ,idStatusPasien = NULL
				  ,tglKeluarPasien = NULL
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			COMMIT TRAN;
			Select 'Billing Tagihan Gawat Darurat Berhasil Dibatalkan, Pasien Kembali Dirawat' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		END CATCH
END