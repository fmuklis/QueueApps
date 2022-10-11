-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaJal_validasiPembayaran]
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
	DECLARE @idStatusPendaftaran int = CASE
										    WHEN EXISTS(SELECT 1 FROM dbo.transaksiOrderRawatInap WHERE idPendaftaranPasien = @idPendaftaranPasien)
												 THEN 4/*Order Rawat Inap*/
											ELSE 99/*Pulang*/
										END;
			
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idPendaftaranPasien = @idPendaftaranPasien
					 AND idStatusBayar = 1/*Menunggu Pembayaran*/ AND idJenisBilling <> 6/*Bill Tgihan RaNap*/ AND idBilling <> @idBilling)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.namaJenisBilling +' Belum Dibayar' AS respon, 0 AS responCode
			  FROM dbo.transaksiBillingHeader a
				   Inner Join dbo.masterJenisBilling b On a.idJenisBilling = b.idJenisBilling
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar = 1/*Menunggu Pembayaran*/ AND idBilling <> @idBilling;
		END
	ELSE
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Billing*/
			IF EXISTS(SELECT 1 FROM dbo.transaksiBillingPembayaran a
							 INNER JOIN dbo.masterMetodeBayar b ON a.idMetodeBayar = b.idMetodeBayar
					   WHERE a.idBilling = @idBilling AND b.piutang = 1/*Piutang*/)
				BEGIN
					UPDATE [dbo].[transaksiBillingHeader]
					   SET [tglBayar] = @tglBayar
						  ,[idUserBayar] = @idUserBayar
						  ,[idJenisBayar] = 3/*Piutang Pribadi*/
						  ,[idStatusBayar] = 5/*Piutang*/
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
						  ,[idStatusBayar] = 10/*Lunas*/
						  ,[tanggalModifikasi] = GETDATE()
						  ,[keterangan] = @keterangan
					 WHERE idBilling = @idBilling;
				END

			/*UPDATE Status Penjualan Resep*/
			UPDATE a
			   SET a.idStatusPenjualan = 3/*Sudah Dibayar*/
				  ,a.idBilling = @idBilling
			  FROM dbo.farmasiPenjualanHeader a
				   INNER JOIN dbo.farmasiResep b On a.idResep = b.idResep
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien And a.idStatusPenjualan = 2/*Menunggu Pembayaran*/;

			/*UPDATE Status Pendaftaran Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = @idStatusPendaftaran
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			Commit Tran;
			SELECT 'Tagihan Billing Gawat Darurat Berhasil Dibayar' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch	
END