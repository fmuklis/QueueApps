-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_verifikasiDetail_deleteItemApproved]
	-- Add the parameters for the stored procedure here
	@idMutasiRequestApproved bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMutasi bigint
		   ,@idObatDetail int;
		   
	SELECT @idMutasi = idMutasi, @idObatDetail = b.idObatDetail
	  FROM dbo.farmasiMutasiOrderItem a
		   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idItemOrderMutasi = b.idItemOrderMutasi
	 WHERE b.idMutasiRequestApproved = @idMutasiRequestApproved;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi NOT IN(2,3))
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Request BHP'+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN dbo.farmasiStokOpname b ON a.idStokOpname = b.idStokOpname
					WHERE a.idObatDetail = @idObatDetail AND b.idStatusStokOpname = 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Selesaikan Proses Stok Opname Pada Barang Ini' AS respon, 0 AS responCode;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
									    FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiMutasiRequestApproved xb ON xa.idMutasiRequestApproved = xb.idMutasiRequestApproved
									   WHERE xb.idMutasiRequestApproved = @idMutasiRequestApproved) b
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
									  INNER JOIN dbo.farmasiMutasiRequestApproved xb ON xa.idMutasiRequestApproved = xb.idMutasiRequestApproved
								WHERE xb.idMutasiRequestApproved = @idMutasiRequestApproved) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail;

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idMutasiRequestApproved = b.idMutasiRequestApproved
			WHERE b.idMutasiRequestApproved = @idMutasiRequestApproved;

			/*Mengembalikan Stok Farmasi*/
			UPDATE a
			   SET a.stok += ISNULL(b.jumlahDisetujui, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idObatDetail = b.idObatDetail
			 WHERE b.idMutasiRequestApproved = @idMutasiRequestApproved;

			/*Menghapus Item Request*/
			DELETE dbo.farmasiMutasiRequestApproved
			 WHERE idMutasiRequestApproved = @idMutasiRequestApproved;

			/*Update Status Mutasi BHP*/
			IF NOT EXISTS(SELECT 1 FROM dbo.farmasiMutasiOrderItem a INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idItemOrderMutasi = b.idItemOrderMutasi WHERE a.idMutasi = @idMutasi)
				BEGIN
					UPDATE dbo.farmasiMutasi 
					   SET idStatusMutasi = 2/*Request Divalidasi*/
					 WHERE idMutasi = @idMutasi;
				END

			/*Transaction Commit*/
			COMMIT TRAN;

			SELECT 'Item Verifikasi Request BHP Berhasil Dihapus' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END