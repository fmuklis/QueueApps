-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingIgd_batalBayar]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling);
	DECLARE @idStatusPendaftaran int = CASE
										    WHEN EXISTS(SELECT 1 FROM dbo.transaksiOrderRawatInap WHERE idPendaftaranPasien = @idPendaftaranPasien)
												 THEN 4/*Order Rawat Inap*/
											ELSE 98/*Menunggu Pembayaran*/
										END;
			
	SET NOCOUNT ON;
    -- Insert statements for procedure here
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Billing*/
			UPDATE [dbo].[transaksiBillingHeader]
			   SET [tglBayar] = NULL
				  ,[idUserBayar] = NULL
				  ,[idJenisBayar] = NULL
				  ,[idStatusBayar] = 1/*Menunggu Pembayaran*/
				  ,[keterangan] = NULL
			 WHERE [idBilling] = @idBilling;

			/*UPDATE Status Penjualan Apotek*/
			UPDATE a
			   SET a.idStatusPenjualan = 2/*Siap Bayar*/
				  ,a.idBilling = NULL
			  FROM dbo.farmasiPenjualanHeader a
			 WHERE a.idBilling = @idBilling;

			/*UPDATE Status Pendaftaran Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = @idStatusPendaftaran
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			Commit Tran;
			Select 'Tagihan Billing Gawat Darurat Batal Dibayar' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch	
END