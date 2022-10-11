-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_penjualan_entryPenjualan_addRacikan
	-- Add the parameters for the stored procedure here
	@idResep bigint,
	@jumlahKemasan decimal(18, 2),
	@kemasan int,
	@listObat nvarchar(max),
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
		   ,@idRacikan int = (SELECT ISNULL(MAX(idRacikan), 0) + 1 FROM dbo.farmasiResepDetail WHERE idResep = @idResep);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @listRacikan TABLE(idObatDetail bigint NOT NULL, jumlah decimal(18,2) NOT NULL);

	INSERT INTO @listRacikan
			   (idObatDetail
			   ,jumlah)
		 SELECT CAST(LEFT(value, CHARINDEX('#', value) - 1) AS bigint) AS idObatDetail
			   ,CAST(RIGHT(value, CHARINDEX('#', REVERSE(value)) - 1) AS decimal(18,2)) AS jumlah
		   FROM STRING_SPLIT(@listObat, '|') a
		  WHERE value <> '';

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

	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDetail a
					 INNER JOIN @listRacikan b ON a.idObatDetail = b.idObatDetail
			   WHERE a.stok < b.jumlah)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiPenjualanDetail a
						  INNER JOIN @listRacikan b ON a.idObatDetail = b.idObatDetail
				    WHERE idPenjualanHeader = @idPenjualanHeader)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Item Penjualan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpnameDetail a
						  INNER JOIN dbo.farmasiStokOpname b ON a.idStokOpname = b.idStokOpname
						  INNER JOIN @listRacikan c ON a.idObatDetail = c.idObatDetail
					WHERE b.idStatusStokOpname = 1/*Entry SO*/)
		BEGIN
			SELECT 'Item Penjualan Sedang Distok Opname, Selesaikan Terlebih Dahulu' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY

			/*Transaction Begin*/
			BEGIN TRAN;

			/*Declare Table Variable*/
			DECLARE @insertedResepRacikan table(idObatDetail bigint, idResepDetail bigint);

			/*INSERT Resep Detail*/
			INSERT INTO [dbo].[farmasiResepDetail]
					   ([idResep]
					   ,[idRacikan]
					   ,[idObatDosis]
					   ,[idKemasan]
					   ,[jumlahKemasan]
					   ,[jumlah]
					   ,[kaliKonsumsi]
					   ,[jumlahKonsumsi]
					   ,[idTakaran]
					   ,[idSaatKonsumsi]
					   ,[idResepWaktu]
					   ,[keterangan]
					   ,[idUserEntry])
				 SELECT @idResep
					   ,@idRacikan
					   ,b.idObatDosis
					   ,@kemasan
					   ,@jumlahKemasan
					   ,SUM(a.jumlah)
					   ,@kali
					   ,@dosisTakaran
					   ,@takaran
					   ,@saatkonsumsi
					   ,@waktu
					   ,@keterangan
					   ,@idUserEntry
				   FROM @listRacikan a
						INNER JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
			   GROUP BY b.idObatDosis;

			/*INSERT Data Penjualan*/
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
					   ,ba.idResepDetail
					   ,a.jumlah
					   ,b.hargaPokok
					   ,dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail)
					   ,@idUserEntry
				   FROM @listRacikan a
						INNER JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
							INNER JOIN dbo.farmasiResepDetail ba On b.idObatDosis = ba.idObatDosis
				  WHERE ba.idResep = @idResep AND ba.idRacikan = @idRacikan;
							
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
							INNER JOIN dbo.farmasiResepDetail ba ON b.idObatDosis = ba.idObatDosis
						INNER JOIN @listRacikan c ON a.idObatDetail = c.idObatDetail
				  WHERE ba.idResep = @idResep AND ba.idRacikan = @idRacikan;

			/*Mengurangi Stok Barang Farmasi*/
			UPDATE a
			   SET stok -= b.jumlah
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN @listRacikan b ON a.idObatDetail = b.idObatDetail;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Penjualan Resep Racikan Berhasil Disimpan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END