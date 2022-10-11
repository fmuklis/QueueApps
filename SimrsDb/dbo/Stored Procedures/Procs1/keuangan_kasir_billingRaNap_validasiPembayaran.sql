-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_validasiPembayaran]
	-- Add the parameters for the stored procedure here
	@idBilling int,
	@tglBayar date,
	@idUserBayar int,
	@keterangan nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling);
			
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idPendaftaranPasien = @idPendaftaranPasien
					 AND idStatusBayar = 1/*Menunggu Pembayaran*/ AND idBilling <> @idBilling)
		BEGIN
			SELECT TOP 1 'Tidak Dapat Divalidasi, '+ b.namaJenisBilling +' Belum Dibayar' AS respon, 0 AS responCode
			  FROM dbo.transaksiBillingHeader a
				   INNER JOIN dbo.masterJenisBilling b ON a.idJenisBilling = b.idJenisBilling
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar = 1/*Menunggu Pembayaran*/ AND idBilling <> @idBilling;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Update Status Billing*/
			IF EXISTS(SELECT 1 FROM dbo.transaksiBillingPembayaran WHERE idBilling = @idBilling AND idMetodeBayar = 4/*Piutang Pribadi*/)
				BEGIN
					UPDATE [dbo].[transaksiBillingHeader]
					   SET [tglBayar] = @tglBayar
						  ,[idUserBayar] = @idUserBayar
						  ,[idJenisBayar] = 3/*Piutang Pribadi*/
						  ,[idStatusBayar] = 5/*Piutang Pembayaran*/
						  ,[tanggalModifikasi] = GETDATE()
						  ,[keterangan] = @keterangan
					 WHERE [idBilling] = @idBilling;
				END
			ELSE
				BEGIN
					UPDATE [dbo].[transaksiBillingHeader]
					   SET [tglBayar] = @tglBayar
						  ,[idUserBayar] = @idUserBayar
						  ,[idJenisBayar] = 1/*Cash/Lunas*/
						  ,[idStatusBayar] = 10/*Selesai Pembayaran*/
						  ,[tanggalModifikasi] = GETDATE()
						  ,[keterangan] = @keterangan
					 WHERE idBilling = @idBilling;
				END

			/*UPDATE Status Penjualan Apotek*/
			UPDATE a
			   SET a.idStatusPenjualan = 3/*Sudah Dibayar*/
				  ,a.idBilling = @idBilling
			  FROM dbo.farmasiPenjualanHeader a
				   Inner Join dbo.farmasiResep b On a.idResep = b.idResep
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien And a.idStatusPenjualan = 2/*Menunggu Pembayaran*/;

			/*UPDATE Status Pendaftaran Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 99/*Closed/Pulang*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Tagihan Billing Rawat Inap Dibayar' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH	
END