-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [farmasi_penjualan_entryPenjualan_deleteItemPenjualan]
	-- Add the parameters for the stored procedure here
	@idPenjualanDetail bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idResep bigint
		   ,@idPenjualanHeader bigint
		   ,@idResepDetail bigint;
		   
	SELECT @idResep = a.idResep,  @idPenjualanHeader = b.idPenjualanHeader, @idResepDetail = a.idResepDetail
	  FROM dbo.farmasiResepDetail a
		   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idResepDetail = b.idResepDetail
	 WHERE b.idPenjualanDetail = @idPenjualanDetail;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPenjualanHeader WHERE idPenjualanHeader = @idPenjualanHeader AND idStatusPenjualan = 3/*Resep Telah Dibayar*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPenjualanHeader a
				   LEFT JOIN dbo.farmasiMasterStatusPenjualan b ON a.idStatusPenjualan = b.idStatusPenjualan
			 WHERE a.idPenjualanHeader = @idPenjualanHeader;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
									    FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
									   WHERE xb.idPenjualanDetail = @idPenjualanDetail) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Stok Akhir Minus Terhadap Koreksi' AS respon, 0 AS responCode;
		END
	ELSE
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*Koreksi Jurnal Stok*/
			UPDATE a
			   SET a.stokAwal += b.jumlahKeluar
				  ,a.stokAkhir += b.jumlahKeluar
			  FROM dbo.farmasiJurnalStok a
				   OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahMasuk, xa.jumlahKeluar
								 FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
								WHERE xb.idPenjualanDetail = @idPenjualanDetail) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail;

			/*UPDATE Stok Farmasi*/
			UPDATE a
			   SET a.stok += b.jumlah
			  FROM dbo.farmasiMasterObatDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
			 WHERE b.idPenjualanDetail = @idPenjualanDetail;

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idPenjualanDetail = b.idPenjualanDetail
			WHERE b.idPenjualanDetail = @idPenjualanDetail;

			/*Update Jumlah resep Detail Tambahan*/
			UPDATE a
			   SET a.jumlah -= b.jumlah
			  FROM dbo.farmasiResepDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idResepDetail = b.idResepDetail
			 WHERE b.idPenjualanDetail = @idPenjualanDetail AND a.idUserEntry = b.idUserEntry;

			/*DELETE Data Penjualan*/
			DELETE [dbo].[farmasiPenjualanDetail]
			 WHERE idPenjualanDetail = @idPenjualanDetail;

			/*Hapus Resep Detail Tambahan Oleh Petugas Apotek*/
			DELETE dbo.farmasiResepDetail
			 WHERE idResepDetail = @idResepDetail AND ISNULL(jumlah, 0) = 0;

			/*Transaction Commit*/
			Commit Tran;
			Select 'Data Penjualan Resep Berhasil Dihapus' AS respon, 1 AS responCode;
		End Try 
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END