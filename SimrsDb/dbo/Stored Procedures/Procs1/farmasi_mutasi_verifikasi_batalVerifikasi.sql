-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE farmasi_mutasi_verifikasi_batalVerifikasi
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 3/*Verifikasi Request*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Verifikasi, Request Mutasi '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail a 
						  INNER JOIN dbo.farmasiStokOpname b ON a.idStokOpname = b.idStokOpname
						  INNER JOIN dbo.farmasiMutasiRequestApproved c ON a.idObatDetail = c.idObatDetail
								INNER JOIN dbo.farmasiMutasiOrderItem ca ON c.idItemOrderMutasi = ca.idItemOrderMutasi
					WHERE ca.idMutasi = @idMutasi AND b.idStatusStokOpname = 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Verifikasi, Selesaikan Proses Stok Opname' AS respon, 0 AS responCode;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
									    FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiMutasiRequestApproved xb ON xa.idMutasiRequestApproved = xb.idMutasiRequestApproved
											 INNER JOIN dbo.farmasiMutasiOrderItem xc ON xb.idItemOrderMutasi = xc.idItemOrderMutasi
									   WHERE xc.idMutasi = @idMutasi) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Batal Verifikasi, Stok Akhir Minus Terhadap Koreksi' AS respon, 0 AS responCode;
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
									  INNER JOIN dbo.farmasiMutasiOrderItem xc ON xb.idItemOrderMutasi = xc.idItemOrderMutasi
							    WHERE xc.idMutasi = @idMutasi) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail;

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idMutasiRequestApproved = b.idMutasiRequestApproved
						INNER JOIN dbo.farmasiMutasiOrderItem ba ON b.idItemOrderMutasi = ba.idItemOrderMutasi
			WHERE ba.idMutasi = @idMutasi;

			/*Mengembalikan Stok Farmasi*/
			UPDATE a
			   SET a.stok += ISNULL(b.jumlahDisetujui, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idObatDetail = b.idObatDetail
						INNER JOIN dbo.farmasiMutasiOrderItem ba ON b.idItemOrderMutasi = ba.idItemOrderMutasi
			 WHERE ba.idMutasi = @idMutasi;

			/*Menghapus Item Request*/
			DELETE a
			  FROM dbo.farmasiMutasiRequestApproved a
				   INNER JOIN dbo.farmasiMutasiOrderItem b ON a.idItemOrderMutasi = b.idItemOrderMutasi
			 WHERE b.idMutasi = @idMutasi;

			/*Update Status Mutasi BHP*/
			IF NOT EXISTS(SELECT 1 FROM dbo.farmasiMutasiOrderItem a INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idItemOrderMutasi = b.idItemOrderMutasi WHERE a.idMutasi = @idMutasi)
				BEGIN
					UPDATE dbo.farmasiMutasi 
					   SET idStatusMutasi = 2/*Request Divalidasi*/
					 WHERE idMutasi = @idMutasi;
				END

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Verifikasi Request Mutasi Dibatalkan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END