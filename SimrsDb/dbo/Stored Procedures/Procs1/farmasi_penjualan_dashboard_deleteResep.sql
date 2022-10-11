-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_penjualan_dashboard_deleteResep
	-- Add the parameters for the stored procedure here
	@idResep int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiResep WHERE idResep = @idResep AND idStatusResep > 2/*Sedang Diproses*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiResep a
				   LEFT JOIN dbo.farmasiMasterStatusResep b On a.idStatusResep = b.idStatusResep
			 WHERE a.idResep = @idResep;
		END	
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
										FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
											 INNER JOIN dbo.farmasiResepDetail xc ON xb.idResepDetail = xc.idResepDetail
									   WHERE xc.idResep = @idResep) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Stok Akhir Barang Farmasi Minus Terhadap Koreksi' AS respon, 0 AS responCode;
		END	
	ELSE
		BEGIN TRY
			BEGIN TRAN;

			/*Koreksi Jurnal Stok*/
			UPDATE a
			   SET a.stokAwal += b.jumlahKeluar
				  ,a.stokAkhir += b.jumlahKeluar
			  FROM dbo.farmasiJurnalStok a
				   OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
								 FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
									  INNER JOIN dbo.farmasiResepDetail xc ON xb.idResepDetail = xc.idResepDetail
							    WHERE xc.idResep = @idResep) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idPenjualanDetail = b.idPenjualanDetail
						INNER JOIN dbo.farmasiResepDetail ba ON b.idResepDetail = ba.idResepDetail
			 WHERE ba.idResep = @idResep;


			/*Mengembalikan Stok Farmasi*/
			UPDATE a
			   SET a.stok += ISNULL(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						INNER JOIN dbo.farmasiResepDetail ba On b.idResepDetail = ba.idResepDetail
			 WHERE ba.idResep = @idResep;

			/*DELETE Penjualan Detail*/
			DELETE a
			  FROM dbo.farmasiPenjualanDetail a
				   INNER JOIN dbo.farmasiResepDetail b ON a.idResepDetail = b.idResepDetail
			 WHERE b.idResep = @idResep;

			/*DELETE Resep*/
			DELETE dbo.farmasiResep
			 WHERE idResep = @idResep;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Resep Berhasil Dihapus' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END