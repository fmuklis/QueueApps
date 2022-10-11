-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_bhp_verifikasi_batalValidasi]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 4/*Request Diterima*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Request BHP'+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMutasiOrderItem a
						  INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idItemOrderMutasi = b.idItemOrderMutasi
						  LEFT JOIN dbo.farmasiMasterObatDetail c ON b.idMutasiRequestApproved = c.idMutasiRequestApproved
					WHERE a.idMutasi = @idMutasi AND b.jumlahDisetujui > ISNULL(c.stok, 0))
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Item BHP Telah Terjual' AS respon, 0 AS responCode;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xd.idObatDetail, xa.jumlahMasuk
									    FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiMutasiRequestApproved xb ON xa.idMutasiRequestApproved = xb.idMutasiRequestApproved
											 INNER JOIN dbo.farmasiMutasiOrderItem xc ON xb.idItemOrderMutasi = xc.idItemOrderMutasi
											 INNER JOIN dbo.farmasiMasterObatDetail xd ON xb.idMutasiRequestApproved = xd.idMutasiRequestApproved
									   WHERE xc.idMutasi = @idMutasi) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir - b.jumlahMasuk < 0)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Stok Akhir Minus Terhadap Koreksi' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Koreksi Jurnal Stok*/
			UPDATE a
			   SET a.stokAwal -= b.jumlahMasuk
				  ,a.stokAkhir -= b.jumlahMasuk
			  FROM dbo.farmasiJurnalStok a
				   OUTER APPLY(SELECT xa.idLog, xd.idObatDetail, xa.jumlahMasuk
							     FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiMutasiRequestApproved xb ON xa.idMutasiRequestApproved = xb.idMutasiRequestApproved
									  INNER JOIN dbo.farmasiMutasiOrderItem xc ON xb.idItemOrderMutasi = xc.idItemOrderMutasi
									  INNER JOIN dbo.farmasiMasterObatDetail xd ON xb.idMutasiRequestApproved = xd.idMutasiRequestApproved
								WHERE xc.idMutasi = @idMutasi) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail;

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
						INNER JOIN dbo.farmasiMutasiRequestApproved ba ON b.idMutasiRequestApproved = ba.idMutasiRequestApproved
						INNER JOIN dbo.farmasiMutasiOrderItem bb ON ba.idItemOrderMutasi = bb.idItemOrderMutasi
				  WHERE bb.idMutasi = @idMutasi;
			
			/*Mengembalikan Stok BHP*/
			UPDATE a
			   SET a.stok -= ISNULL(b.jumlahDisetujui, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idMutasiRequestApproved = b.idMutasiRequestApproved
						INNER JOIN dbo.farmasiMutasiOrderItem ba ON b.idItemOrderMutasi = ba.idItemOrderMutasi
			 WHERE ba.idMutasi = @idMutasi;

			/*Menghapus Stok BHP*/
			DELETE a
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idMutasiRequestApproved = b.idMutasiRequestApproved
						INNER JOIN dbo.farmasiMutasiOrderItem ba ON b.idItemOrderMutasi = ba.idItemOrderMutasi
			 WHERE ba.idMutasi = @idMutasi AND ISNULL(a.stok, 0) = 0;

			/*Update Id Mutasi Terakhir*/
			UPDATE a
			   SET a.idMutasiRequestApproved = c.idMutasiRequestApproved
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idMutasiRequestApproved = b.idMutasiRequestApproved
						INNER JOIN dbo.farmasiMutasiOrderItem ba ON b.idItemOrderMutasi = ba.idItemOrderMutasi
				   OUTER APPLY (SELECT MAX(xa.idMutasiRequestApproved) AS idMutasiRequestApproved
								  FROM dbo.farmasiJurnalStok xa 
								 WHERE a.idObatDetail = xa.idObatDetail) c
			 WHERE ba.idMutasi = @idMutasi;

			/*Update Status Request BHP*/
			UPDATE dbo.farmasiMutasi
			   SET idStatusMutasi = 3/*Proses Verifikasi*/
				  ,kodeMutasi = '-'
				  ,tanggalAprove = NULL
				  ,petugasPenerima = NULL
				  ,petugasPenyerahan = NULL
				  ,idUserVerifikasi = NULL
				  ,tanggalModifikasi = GETDATE()
			 WHERE idMutasi = @idMutasi;

			/*Transaction Commit*/
			COMMIT TRAN;

			SELECT 'Penyerahan BHP Berhasil Dibatalkan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END