-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_batalValidasiStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname AND idStatusStokOpname <> 5/*valid / Selesai*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiStokOpname a
				   LEFT JOIN dbo.farmasiMasterStatusStokOpname b ON a.idStatusStokOpname = b.idStatusStokOpname
			 WHERE a.idStokOpname = @idStokOpname;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail a LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail
					WHERE a.idJenisStokOpname = 1/*Tambah Stok*/ AND a.jumlahStokOpname <> ISNULL(b.stok, 0) AND idStokOpname = @idStokOpname)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Barang Farmasi Telah Terjual' AS respon, 0 AS responCode
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail a LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail
					WHERE a.idJenisStokOpname = 2/*Koreksi Stok*/ AND a.jumlahStokOpname > ISNULL(b.stok, 0) AND idStokOpname = @idStokOpname)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Barang Farmasi Telah Terjual' AS respon, 0 AS responCode
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahMasuk, xa.jumlahKeluar
									    FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiStokOpnameDetail xb ON xa.idStokOpnameDetail = xb.idStokOpnameDetail
									   WHERE xb.idStokOpname = @idStokOpname) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir - b.jumlahMasuk + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Stok Akhir Minus Terhadap Koreksi' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Koreksi Jurnal Stok Farmasi*/
			UPDATE a
			   SET a.stokAwal -= b.jumlahMasuk + b.jumlahKeluar
				  ,a.stokAkhir -= b.jumlahMasuk + b.jumlahKeluar
			  FROM dbo.farmasiJurnalStok a
				   OUTER APPLY(SELECT xb.idLog, xb.idObatDetail, xb.jumlahMasuk, xb.jumlahKeluar
								 FROM dbo.farmasiStokOpnameDetail xa
									  INNER JOIN dbo.farmasiJurnalStok xb ON xa.idStokOpnameDetail = xb.idStokOpnameDetail
								WHERE xa.idStokOpname = @idStokOpname) b
			WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail;

			/*Delete Jurnal Stok Opname*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiStokOpnameDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail
			 WHERE b.idStokOpname = @idStokOpname;

			/*Koreksi Stok Farmasi Proses Stok Opname Koreksi Stok*/
			UPDATE a
			   SET [stok] = b.jumlahAwal - (b.jumlahStokOpname - a.stok)
				  ,a.idStokOpnameDetail = c.idStokOpnameDetail
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiStokOpnameDetail b ON a.idObatDetail = b.idObatDetail AND b.idJenisStokOpname = 2/*Koreksi Stok*/
				   OUTER APPLY (SELECT MAX(xa.idStokOpnameDetail) AS idStokOpnameDetail
								  FROM dbo.farmasiStokOpnameDetail xa
									   INNER JOIN dbo.farmasiStokOpname xb ON xa.idStokOpname = xb.idStokOpname
								 WHERE a.idObatDetail = xa.idObatDetail AND xb.idStatusStokOpname = 5/*Valid / Selesai*/
									   AND xa.idStokOpname <> @idStokOpname) c
			 WHERE b.idStokOpname = @idStokOpname;

			/*Update Generated idObatDetail To Table dbo.farmasiStokOpnameDetail Proses Stok Opname Tambah Stok*/
			UPDATE a
			   SET a.idObatDetail = NULL
			  FROM dbo.farmasiStokOpnameDetail a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail
			 WHERE a.idJenisStokOpname = 1/*Tambah Stok*/ AND a.idStokOpname = @idStokOpname;

			/*Delete Stok Barang Farmasi Proses Stok Opname Tambah Stok*/
			DELETE a
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiStokOpnameDetail b ON a.idStokOpnameDetail = b.idStokOpnameDetail AND b.idJenisStokOpname = 1/*Tambah Stok*/
			 WHERE b.idStokOpname = @idStokOpname;

			/*Update Harga Jual Farmasi*/
			UPDATE a
			   SET a.hargaJual = dbo.generate_hargaJualBarangFarmasi(b.idObatDetail)
			  FROM dbo.farmasiMasterObatDosis a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDosis = b.idObatDosis
						INNER JOIN dbo.farmasiStokOpnameDetail ba ON b.idObatDosis = ba.idObatDosis
			 WHERE ba.idStokOpname = @idStokOpname;

			/*Update Data Stok Opname*/
			UPDATE [dbo].[farmasiStokOpname]
			   SET [kodeStokOpname] = NULL
				  ,[idStatusStokOpname] = 1/*Proses Entry*/
				  ,[tanggalModifikasi] = GETDATE()
			 WHERE idStokOpname = @idStokOpname;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Stok Opname BHP Batal Divalidasi' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Rollback Transaction*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END