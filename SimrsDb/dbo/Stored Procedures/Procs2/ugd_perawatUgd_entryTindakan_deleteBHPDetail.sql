-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_deleteBHPDetail]
	-- Add the parameters for the stored procedure here
	@idPenjualanDetail int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPenjualanDetail a
					 INNER JOIN dbo.transaksiTindakanPasien b ON a.idTindakanPasien = b.idTindakanPasien
					 INNER JOIN dbo.transaksiBillingHeader bb ON b.idPendaftaranPasien = bb.idPendaftaranPasien  And b.idJenisBilling = bb.idJenisBilling
			   WHERE a.idPenjualanDetail = @idPenjualanDetail AND bb.idStatusBayar <> 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, BHP Sudah Dibayar' AS respon, 0 AS responCode;
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
								WHERE xb.idPenjualanDetail = @idPenjualanDetail) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail;

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idPenjualanDetail = b.idPenjualanDetail
			WHERE b.idPenjualanDetail = @idPenjualanDetail;

			/*Mengembalikan Stok BHP Ruangan*/
			UPDATE a
			   SET a.stok += ISNULL(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idObatDetail = b.idObatDetail
			 WHERE b.idPenjualanDetail = @idPenjualanDetail;

			/*Delete BHP Tindakan*/
			DELETE [dbo].[farmasiPenjualanDetail]
			 WHERE idPenjualanDetail = @idPenjualanDetail;

			/*Transaction Commit*/
			COMMIT TRAN;
			Select 'BHP Tindakan Berhasil Dihapus' As respon, 1 As responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;			
		END CATCH
END