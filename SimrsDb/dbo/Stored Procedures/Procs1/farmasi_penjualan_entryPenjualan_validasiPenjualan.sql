-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_entryPenjualan_validasiPenjualan]
	-- Add the parameters for the stored procedure here
	@idResep bigint,
	@idUserEntry int,
	@idPetugasFarmasi int,
	@tglJual date,
	@flagKaryawan bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.	
	SET NOCOUNT ON;

	DECLARE @currentDate datetime = GETDATE()
		   ,@idPendaftaranPasien bigint
		   ,@idPenjualanHeader bigint;

	SELECT @idPendaftaranPasien = a.idPendaftaranPasien, @idPenjualanHeader = b.idPenjualanHeader
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.farmasiPenjualanHeader b ON a.idResep = b.idResep
	 WHERE a.idResep = @idResep;
    
	IF NOT EXISTS(SELECT 1 FROM dbo.farmasiPenjualanHeader a
						 INNER JOIN dbo.farmasiPenjualanDetail b ON a.idPenjualanHeader = b.idPenjualanHeader
				   WHERE a.idResep = @idResep)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Penjualan Resep Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE IF NOT EXISTS(SELECT 1 FROM dbo.farmasiResep WHERE idResep = @idResep AND idStatusResep = 2/*Resep Diproses*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiResep a
				   LEFT JOIN dbo.farmasiMasterStatusResep b ON a.idStatusResep = b.idStatusResep
			 WHERE a.idResep = @idResep
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;
			
			/*UPDATE Status Penjualan Farmasi*/
			UPDATE [dbo].[farmasiPenjualanHeader]
			   SET [idStatusPenjualan] = 2/*Siap Bayar*/
				  ,tglJual = @tglJual
				  ,idPetugasFarmasi = @idPetugasFarmasi
				  ,flagKaryawan = @flagKaryawan
			 WHERE idPenjualanHeader = @idPenjualanHeader;

			/*UPDATE Penjualan Detail*/
			IF @flagKaryawan = 1
				BEGIN
					UPDATE dbo.farmasiPenjualanDetail
					   SET ditagih = 0/*Tidak Ditagih*/
					 WHERE idPenjualanHeader = @idPenjualanHeader;
				END

			/*UPDATE Status Resep*/
			UPDATE dbo.farmasiResep 
			   SET idStatusResep = 3/*Resep Selesai*/
				  ,nomorResep = dbo.generate_nomorResep(tglResep)
				  ,validationDate = CONCAT(@tglJual, ' ', CAST(@currentDate AS time(0)))
				  ,tanggalModifikasi = @currentDate
			 WHERE idResep = @idresep;

			/*Verifikasi Billing Resep*/
			IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien a
							 INNER JOIN dbo.masterJenisPenjaminPembayaranPasien b ON a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
							 LEFT JOIN transaksiBillingHeader d ON a.idPendaftaranPasien = d.idPendaftaranPasien AND d.idResep = @idResep
					   WHERE a.idStatusPendaftaran >= 98 AND a.idJenisPerawatan = 2/*RaJal*/ AND b.idJenisPenjaminInduk = 1/*UMUM*/
							 AND d.idBilling IS NULL AND a.idPendaftaranPasien = @idPendaftaranPasien)
				BEGIN
					INSERT INTO [dbo].[transaksiBillingHeader]
							   ([kodeBayar]
							   ,[idPendaftaranPasien]
							   ,[idDokter]
							   ,[idRuangan]
							   ,[idResep]
							   ,[idJenisBilling]
							   ,[idUserEntry])
						 SELECT dbo.noKwitansi()
							   ,a.idPendaftaranPasien
							   ,a.idDokter
							   ,a.idRuangan
							   ,a.idResep
							   ,3/*Billing Farmasi*/
							   ,@idUserEntry
						   FROM dbo.farmasiResep a
						  WHERE a.idResep = @idResep;				
				END

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Penjualan Resep Berhasil Divalidasi ' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END