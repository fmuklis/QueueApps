-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameDetail_validasiStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname AND idStatusStokOpname <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiStokOpname a
				   LEFT JOIN dbo.farmasiMasterStatusStokOpname b ON a.idStatusStokOpname = b.idStatusStokOpname
			 WHERE a.idStokOpname = @idStokOpname;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail WHERE idStokOpname = @idStokOpname)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Tambah / Koreksi Barang Farmasi Belum Dientry' AS respon, 0 AS responCode
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Update Stok Awal Stok Opname Koreksi Stok*/
			UPDATE a
			   SET a.jumlahAwal = b.stok
			  FROM dbo.farmasiStokOpnameDetail a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
			 WHERE a.idJenisStokOpname = 2/*Koreksi Stok*/ AND a.idStokOpname = @idStokOpname;

			/*Koreksi Stok*/
			UPDATE a
			   SET [stok] = b.jumlahStokOpname
				  ,a.idStokOpnameDetail = b.idStokOpnameDetail
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiStokOpnameDetail b ON a.idObatDetail = b.idObatDetail AND b.idJenisStokOpname = 2/*Koreksi Stok*/
			 WHERE b.idStokOpname = @idStokOpname;
			
			/*Buat Jurnal Koreksi Stok*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idStokOpnameDetail]
					   ,[stokAwal]
					   ,[jumlahMasuk]
					   ,[jumlahKeluar]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT b.idObatDetail
					   ,a.idStokOpnameDetail
					   ,a.jumlahAwal
					   ,CASE
							 WHEN a.jumlahAwal < a.jumlahStokOpname
								  THEN a.jumlahStokOpname - a.jumlahAwal
							 ELSE 0
						 END
					   ,CASE
							 WHEN a.jumlahAwal > a.jumlahStokOpname
								  THEN a.jumlahAwal - a.jumlahStokOpname
							 ELSE 0
						 END					
					   ,a.jumlahStokOpname
					   ,a.idUserEntry
				   FROM dbo.farmasiStokOpnameDetail a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail
				  WHERE a.idJenisStokOpname = 2/*Koreksi Stok*/ AND a.idStokOpname = @idStokOpname;

			/*Tambah Stok Barang Farmasi*/
			INSERT INTO [dbo].[farmasiMasterObatDetail]
					   ([idMetodeStok]
					   ,[idJenisStok]
					   ,[idObatDosis]
					   ,[kodeBatch]
					   ,[tglExpired]
					   ,[tglStokAtauTglBeli]
					   ,[stok]
					   ,[hargaPokok]
					   ,[idStokOpnameDetail]
					   ,[idUserEntry])
				 SELECT 2/*Stok Opname*/
					   ,a.idJenisStok
					   ,b.idObatDosis
					   ,b.kodeBatch
					   ,b.tglExpired
					   ,a.tanggalStokOpname
					   ,b.jumlahStokOpname
					   ,b.hargaPokok
					   ,b.idStokOpnameDetail
					   ,b.idUserEntry
				   FROM dbo.farmasiStokOpname a
						INNER JOIN dbo.farmasiStokOpnameDetail b ON a.idStokOpname = b.idStokOpname AND b.idJenisStokOpname = 1/*Tambah Stok*/
				  WHERE a.idStokOpname = @idStokOpname;

			/*Update Generated idObatDetail To Table dbo.farmasiStokOpnameDetail*/
			UPDATE a
			   SET a.idObatDetail = b.idObatDetail
			  FROM dbo.farmasiStokOpnameDetail a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail
			 WHERE a.idStokOpname = @idStokOpname;
			
			/*Buat Jurnal Stok Masuk*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idStokOpnameDetail]
					   ,[stokAwal]
					   ,[jumlahMasuk]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT b.idObatDetail
					   ,a.idStokOpnameDetail
					   ,a.jumlahAwal
					   ,a.jumlahStokOpname
					   ,a.jumlahStokOpname
					   ,a.idUserEntry
				   FROM dbo.farmasiStokOpnameDetail a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail
				  WHERE a.idJenisStokOpname = 1/*Tambah Stok*/ AND a.idStokOpname = @idStokOpname;

			/*Update Harga Jual Farmasi*/
			UPDATE a
			   SET a.hargaJual = dbo.generate_hargaJualBarangFarmasi(b.idObatDetail)
			  FROM dbo.farmasiMasterObatDosis a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDosis = b.idObatDosis
						INNER JOIN dbo.farmasiStokOpnameDetail ba ON b.idStokOpnameDetail = ba.idStokOpnameDetail
			 WHERE ba.idStokOpname = @idStokOpname;

			/*Update Data Stok Opname*/
			UPDATE [dbo].[farmasiStokOpname]
			   SET [kodeStokOpname] = dbo.generate_nomorStokOpname(tanggalStokOpname)
				  ,[idStatusStokOpname] = 5/*Valid / Selesai*/
				  ,[tanggalModifikasi] = GETDATE()
			 WHERE idStokOpname = @idStokOpname;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Stok Opname Berhasil Divalidasi' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Rollback Transaction*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END