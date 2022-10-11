-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_batalValidasiPenerimaan]
	-- Add the parameters for the stored procedure here
	@idPembelianHeader bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPembelian WHERE idPembelianHeader = @idPembelianHeader AND idStatusPembelian <> 2/*Barang Diterima*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPembelian a
				   LEFT JOIN dbo.farmasiMasterStatusPembelian b On a.idStatusPembelian = b.idStatusPembelian
			 WHERE a.idPembelianHeader = @idPembelianHeader;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPembelianDetail a LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idPembelianDetail = b.idPembelianDetail
					WHERE a.jumlahBeli > ISNULL(b.stok, 0) AND idPembelianHeader = @idPembelianHeader)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Barang Farmasi Telah Didistribusikan / Dijual' AS respon, 0 AS responCode
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahMasuk, xa.jumlahKeluar
									    FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiPembelianDetail xb ON xa.idPembelianDetail = xb.idPembelianDetail
									   WHERE xb.idPembelianHeader = @idPembelianHeader) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir - b.jumlahMasuk + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Stok Akhir Minus Terhadap Koreksi' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			Begin Tran;

			/*Delete Jurnal Stok Masuk*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPembelianDetail b ON a.idPembelianDetail = b.idPembelianDetail
			 WHERE b.idPembelianHeader = @idPembelianHeader;

			/*Delete Stok Gudang*/
			DELETE a
		 	  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPembelianDetail b ON a.idPembelianDetail = b.idPembelianDetail
		     WHERE b.idPembelianHeader = @idPembelianHeader;

			/*Update Harga Jual Obat*/
			UPDATE a
			   SET [hargaJual] = dbo.generate_hargaJualBarangFarmasi(c.idObatDetail)
			  FROM [dbo].[farmasiMasterObatDosis] a
				   INNER JOIN dbo.farmasiOrderDetail b ON a.idObatDosis = b.idObatDosis
						INNER JOIN dbo.farmasiPembelianDetail ba ON b.idOrderDetail = ba.idOrderDetail
				   INNER JOIN dbo.farmasiMasterObatDetail c ON a.idObatDosis = c.idObatDosis
			 WHERE ba.idPembelianHeader = @idPembelianHeader;

			/*Update Status Pembelian Gudang Farmasi*/
			UPDATE dbo.farmasiPembelian
			   SET idStatusPembelian = 1/*Proses Entry Penerimaan*/
			 WHERE idPembelianHeader = @idPembelianHeader;

			/*Update Status Order Gudang Farmasi*/
			UPDATE a
			   SET idStatusOrder = 3/*Proses Entry Penerimaan*/
				  ,tanggalModifikasi = GETDATE()
			  FROM dbo.farmasiOrder a
				   INNER JOIN dbo.farmasiPembelian b ON a.idOrder = b.idOrder
			 WHERE b.idPembelianHeader = @idPembelianHeader;

			Commit Tran;
			Select 'Data Penerimaan Barang Farmasi Batal Divalidasi' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error !: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END