-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_batalBayar]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling);
			
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
			   SET idStatusPendaftaran = 98/*Menunggu Pembayaran*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			Commit Tran;
			Select 'Tagihan Billing Rawat Inap Batal Dibayar' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch	
END