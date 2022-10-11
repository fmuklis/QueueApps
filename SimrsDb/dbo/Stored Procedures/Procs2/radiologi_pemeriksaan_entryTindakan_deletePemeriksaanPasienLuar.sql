-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_entryTindakan_deletePemeriksaanPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrderDetail bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idOrder bigint = (SELECT idOrder FROM dbo.transaksiOrderDetail WHERE idOrderDetail = @idOrderDetail);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 2)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   INNER JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
								 FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
									  INNER JOIN dbo.transaksiTindakanPasien xc ON xb.idTindakanPasien = xc.idTindakanPasien
								WHERE xc.idOrderDetail = @idOrderDetail) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Stok Akhir Minus Terhadap Koreksi' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Koreksi Jurnal Stok*/
			UPDATE a
			   SET a.stokAwal += b.jumlahKeluar
				  ,a.stokAkhir += b.jumlahKeluar
			  FROM dbo.farmasiJurnalStok a
				   OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahMasuk, xa.jumlahKeluar
								 FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
									  INNER JOIN dbo.transaksiTindakanPasien xc ON xb.idTindakanPasien = xc.idTindakanPasien
								WHERE xc.idOrderDetail = @idOrderDetail) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idPenjualanDetail = b.idPenjualanDetail
				   INNER JOIN dbo.transaksiTindakanPasien c ON b.idTindakanPasien = c.idTindakanPasien
			WHERE c.idOrderDetail = @idOrderDetail;
				
			/*Mengembalikan Stok BHP*/
			UPDATE a
			   SET a.stok += b.jumlah
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idObatDetail = b.idObatDetail
						INNER JOIN dbo.transaksiTindakanPasien ba ON b.idTindakanPasien = ba.idTindakanPasien
			 WHERE ba.idOrderDetail = @idOrderDetail;

			/*Menghapus Data BHP*/
			DELETE a
			  FROM dbo.farmasiPenjualanDetail a
				   INNER JOIN dbo.transaksiTindakanPasien b ON a.idTindakanPasien = b.idTindakanPasien
			 WHERE b.idOrderDetail = @idOrderDetail;

			/*Menghapus Item Request Pemeriksaan*/
			DELETE a
			  FROM dbo.transaksiOrderDetail a
				   INNER JOIN dbo.transaksiTindakanPasien b ON a.idOrderDetail = b.idOrderDetail AND a.idUserEntry = b.idUserEntry
			 WHERE a.idOrderDetail = @idOrderDetail;

			/*Menghapus Item Pemeriksaan*/
			DELETE dbo.transaksiTindakanPasien
			 WHERE idOrderDetail = @idOrderDetail;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Pemeriksaan Radiologi Berhasil Dihapus' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH

END