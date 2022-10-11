-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudang_deleteRequest]
	-- Add the parameters for the stored procedure here
	@idRetur bigint
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiRetur WHERE idRetur = @idRetur AND idStatusRetur <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiRetur a
				   LEFT JOIN dbo.farmasiMasterStatusRetur b ON a.idStatusRetur = b.idStatusRetur
			 WHERE a.idRetur = @idRetur;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
								 FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiReturDetail xb ON xa.idReturDetail = xb.idReturDetail
								WHERE xb.idRetur = @idRetur) b
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
									  INNER JOIN dbo.farmasiReturDetail xb ON xa.idReturDetail = xb.idReturDetail
								WHERE xb.idRetur = @idRetur) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiReturDetail b ON a.idReturDetail = b.idReturDetail
			 WHERE b.idRetur = @idRetur;
				
			/*Mengembalikan Stok*/
			UPDATE a
			   SET a.stok += b.jumlahRetur
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiReturDetail b ON a.idObatDetail = b.idObatDetail
			 WHERE b.idRetur = @idRetur;

			/*Menghapus Request Retur Ke Gudang Farmasi*/
			DELETE dbo.farmasiRetur
			 WHERE idRetur = @idRetur;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Permintaan Retur Kegudang Berhasil Dihapus' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END