-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_penjualan_entryPenjualan_addNonRacikan
	-- Add the parameters for the stored procedure here
	@idResep bigint,
	@idObatDetail bigint,
	@jumlah decimal(18,2),
	@kali int,
	@dosisTakaran varchar(50),
	@takaran int,
	@waktu int,
	@saatkonsumsi int,
	@keterangan varchar(250),
    @idUserEntry int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPenjualanHeader bigint
		   ,@idPenjualanDetail bigint
		   ,@idObatDosis int = (SELECT idObatDosis FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail)
		   ,@idResepDetail bigint;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*Add Data Penjualan Header*/
	INSERT INTO [dbo].[farmasiPenjualanHeader]
			   ([idResep]
			   ,[idStatusPenjualan]
			   ,[idUserEntry])
		 SELECT a.idResep
			   ,1/*Dalam Proses Entri*/
			   ,@idUserEntry
		   FROM dbo.farmasiResep a
				LEFT JOIN dbo.farmasiPenjualanHeader b ON a.idResep = b.idResep
		  WHERE a.idResep = @idResep AND b.idPenjualanHeader IS NULL;

	/*Update Status Resep*/
	UPDATE dbo.farmasiResep 
	   SET noResep = dbo.noResep('R')
		  ,idStatusResep = 2/*Resep Diproses*/
	 WHERE idResep = @idResep AND noResep IS NULL;

	/*GET idPenjualanHeader*/
	SELECT @idPenjualanHeader = idPenjualanHeader FROM dbo.farmasiPenjualanHeader WHERE idResep = @idResep;

	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail AND stok < @jumlah)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiPenjualanDetail WHERE idPenjualanHeader = @idPenjualanHeader AND idObatDetail = @idObatDetail)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Item Penjualan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN dbo.farmasiStokOpname b ON a.idStokOpname = b.idStokOpname
					WHERE a.idObatDetail = @idObatDetail AND b.idStatusStokOpname <> 5/*SO Valid*/)
		BEGIN
			SELECT 'Item Penjualan Sedang Distok Opname, Selesaikan Terlebih Dahulu' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			IF NOT EXISTS(SELECT 1 FROM dbo.farmasiResepDetail WHERE idResep = @idResep AND idObatDosis = @idObatDosis AND idRacikan = 0)
				BEGIN
					/*Add Resep Detail*/
					INSERT INTO [dbo].[farmasiResepDetail]
							   ([idResep]
							   ,[idObatDosis]
							   ,[jumlah]
							   ,[kaliKonsumsi]
							   ,[jumlahKonsumsi]
							   ,[idTakaran]
							   ,[idSaatKonsumsi]
							   ,[idResepWaktu]
							   ,[keterangan]
							   ,[idUserEntry])
						 VALUES
							   (@idResep
							   ,@idObatDosis
							   ,@jumlah
							   ,@kali 
							   ,@dosisTakaran
							   ,@takaran
							   ,@saatkonsumsi
							   ,@waktu
							   ,@keterangan
							   ,@idUserEntry);
				END
			ELSE
				BEGIN
					/*UPDATE Resep Detail*/
					UPDATE [dbo].[farmasiResepDetail]
					   SET [jumlah] += @jumlah
						  ,[kaliKonsumsi] = @kali
						  ,[jumlahKonsumsi] = @dosisTakaran
						  ,[idTakaran] = @takaran
						  ,[idSaatKonsumsi] = @saatkonsumsi
						  ,[idResepWaktu] = @waktu
						  ,[keterangan] = @keterangan
						  ,[idUserEntry] = @idUserEntry
					 WHERE idResep = @idResep AND idObatDosis = @idObatDosis AND idRacikan = 0;
				END

			/*GET idResepDetail*/
			SELECT @idResepDetail = idResepDetail FROM dbo.farmasiResepDetail WHERE idRacikan = 0 AND idResep = @idResep AND idObatDosis = @idObatDosis;

			/*Add Data Penjualan*/
			INSERT INTO [dbo].[farmasiPenjualanDetail]
					   ([idPenjualanHeader]
					   ,[idObatDetail]
					   ,[idResepDetail]
					   ,[jumlah]
					   ,[hargaPokok]
					   ,[hargaJual]
					   ,[idUserEntry])
				 SELECT @idPenjualanHeader
					   ,a.idObatDetail
					   ,@idResepDetail
					   ,@jumlah
					   ,a.hargaPokok
					   ,dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail)
					   ,@idUserEntry
					FROM dbo.farmasiMasterObatDetail a
				   WHERE a.idObatDetail = @idObatDetail;

			/*GET @idPenjualanDetail*/
			SET @idPenjualanDetail = SCOPE_IDENTITY();

			/*Add Jurnal Stok Keluar*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idPenjualanDetail]
					   ,[stokAwal]
					   ,[jumlahKeluar]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT a.idObatDetail
					   ,a.idPenjualanDetail
					   ,b.stok
					   ,a.jumlah
					   ,b.stok - a.jumlah
					   ,@idUserEntry
				   FROM dbo.farmasiPenjualanDetail a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
				  WHERE a.idPenjualanDetail = @idPenjualanDetail;

			/*Mengurangi Stok Barang  Farmasi*/
			UPDATE dbo.farmasiMasterObatDetail
			   SET stok -= @jumlah
			 WHERE idObatDetail = @idObatDetail;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Penjualan Resep Berhasil Disimpan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END