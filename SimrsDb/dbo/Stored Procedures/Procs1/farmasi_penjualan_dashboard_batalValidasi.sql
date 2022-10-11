-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_penjualan_dashboard_batalValidasi
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint
		   ,@idPenjualanHeader bigint;

	SELECT @idPenjualanHeader = idPenjualanHeader
	  FROM dbo.farmasiPenjualanHeader
	 WHERE idResep = @idResep;
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPenjualanHeader WHERE idResep = @idResep AND idStatusPenjualan = 3/*Dibayar*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Biaya Tagihan Resep Telah Dibayar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;
			
			/*UPDATE Status Penjualan Farmasi*/
			UPDATE [dbo].[farmasiPenjualanHeader]
			   SET [idStatusPenjualan] = 1/*Entry Penjualan*/
				  ,tglJual = NULL
				  ,idPetugasFarmasi = NULL
				  ,flagKaryawan = 0
			 WHERE idPenjualanHeader = @idPenjualanHeader;

			/*UPDATE Penjualan Detail*/
			UPDATE dbo.farmasiPenjualanDetail
			   SET ditagih = 1/*Ditagih*/
			 WHERE idPenjualanHeader = @idPenjualanHeader;

			/*UPDATE Status Resep*/
			UPDATE dbo.farmasiResep 
			   SET idStatusResep = 2/*Sedang Diproses*/
				  ,nomorResep = NULL
				  ,tanggalModifikasi = NULL
			 WHERE idResep = @idresep;

			/*Delete Billing Resep*/
			DELETE [dbo].[transaksiBillingHeader]
			 WHERE idResep = @idResep AND idStatusBayar = 1/*Menunggu Pembayaran*/;				

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Penjualan Resep Batal Divalidasi ' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END