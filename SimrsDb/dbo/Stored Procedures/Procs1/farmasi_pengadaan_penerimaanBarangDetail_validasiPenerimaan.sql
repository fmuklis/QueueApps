-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarangDetail_validasiPenerimaan]
	-- Add the parameters for the stored procedure here
	@idPembelianHeader bigint,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE	@persentaseHargaJualFarmasi decimal(18,2) = (Select a.persentaseHargaJualFarmasi From dbo.masterKonfigurasi a)
		   ,@idOrder int = (Select b.idOrder From dbo.farmasiPembelianDetail a
								   Inner Join farmasiOrderDetail b On a.idOrderDetail = b.idOrderDetail
							 Where idPembelianHeader = @idPembelianHeader
						  Group By b.idOrder);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	IF EXISTS(SELECT 1 FROM dbo.farmasiPembelian WHERE idPembelianHeader = @idPembelianHeader AND idStatusPembelian <> 1/*Entry Penerimaan*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPembelian a
				   LEFT JOIN dbo.farmasiMasterStatusPembelian b On a.idStatusPembelian = b.idStatusPembelian
			 WHERE a.idPembelianHeader = @idPembelianHeader;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPembelianDetail WHERE idPembelianHeader = @idPembelianHeader)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Penerimaan Barang Farmasi Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			Begin Tran;

			/*Entry Stok Gudang*/
			INSERT INTO [dbo].[farmasiMasterObatDetail]
					   ([idObatDosis]
					   ,[kodeBatch]
					   ,[idJenisStok]
					   ,[idMetodeStok]
					   ,[tglStokAtauTglBeli]
					   ,[tglExpired]
					   ,[stok]
					   ,[hargaPokok]
					   ,[idUserEntry]
					   ,idPembelianDetail)
				 SELECT ba.idObatDosis 
					   ,b.kodeBatch
					   ,1/*Gudang Farmasi*/
					   ,1/*Stok Metode Pembelian*/
					   ,a.tglPembelian 
					   ,b.tglExpired 
					   ,b.jumlahBeli
					   ,dbo.calculator_hargaPokokPenjualan(b.jumlahBeli, b.hargaBeli, b.discountUang, b.discountPersen, a.ppn)
					   ,@idUserEntry
					   ,b.idPembelianDetail
				   FROM dbo.farmasiPembelian a
						INNER JOIN dbo.farmasiPembelianDetail b ON a.idPembelianHeader = b.idPembelianHeader
							INNER JOIN dbo.farmasiOrderDetail ba ON b.idOrderDetail = ba.idOrderDetail
				  WHERE a.idPembelianHeader = @idPembelianHeader;

			/*Add Jurnal Stok Masuk*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idPembelianDetail]
					   ,[jumlahMasuk]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT b.idObatDetail
					   ,a.idPembelianDetail
					   ,b.stok
					   ,b.stok
					   ,b.idUserEntry
				   FROM dbo.farmasiPembelianDetail a
						INNER JOIN dbo.farmasiMasterObatDetail b On a.idPembelianDetail = b.idPembelianDetail
				  WHERE a.idPembelianHeader = @idPembelianHeader;

			/*Update Harga Jual Obat*/
			UPDATE a
			   SET [hargaJual] = dbo.generate_hargaJualBarangFarmasi(b.idObatDetail)
			  FROM [dbo].[farmasiMasterObatDosis] a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDosis = b.idObatDosis
						INNER JOIN dbo.farmasiPembelianDetail ba ON b.idPembelianDetail = ba.idPembelianDetail
			 WHERE ba.idPembelianHeader = @idPembelianHeader;

			/*Update Status Pembelian Gudang Farmasi*/
			UPDATE dbo.farmasiPembelian
			   SET idStatusPembelian = 2/*Telah Divalidasi*/
			 WHERE idPembelianHeader = @idPembelianHeader;

			/*Update Status Order Gudang Farmasi*/
			UPDATE a
			   SET idStatusOrder = 4/*Barang Diterima*/
				  ,tanggalModifikasi = GETDATE()
			  FROM dbo.farmasiOrder a
				   CROSS APPLY (SELECT xa.idOrder
								  FROM dbo.farmasiOrderDetail xa
									   LEFT JOIN dbo.farmasiPembelianDetail xb ON xa.idOrderDetail = xb.idOrderDetail
								 WHERE xa.idOrder = @idOrder
							  GROUP BY xa.idOrder, xa.idOrderDetail, xa.jumlah
							    HAVING xa.jumlah = SUM(xb.jumlahBeli)) b
			 WHERE a.idOrder = b.idOrder;

			Commit Tran;
			Select 'Data Penerimaan Barang Farmasi Berhasil Divalidasi' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error !: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch
END