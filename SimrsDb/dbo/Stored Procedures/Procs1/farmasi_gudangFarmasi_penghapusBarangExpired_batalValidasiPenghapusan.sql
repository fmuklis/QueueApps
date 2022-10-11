-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_batalValidasiPenghapusan]
	-- Add the parameters for the stored procedure here
	@idPenghapusanStok bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPenghapusanStok WHERE idPenghapusanStok = @idPenghapusanStok AND idStatusPenghapusan <> 5 /* Validasi */)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPenghapusanStok a
				   LEFT JOIN dbo.farmasiMasterStatusPenghapusan b ON a.idStatusPenghapusan = b.idStatusPenghapusan
			WHERE a.idPenghapusanStok = @idPenghapusanStok
		END
	ELSE 
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Mengembalikan Stok Awal*/
			UPDATE a
			   SET a.stok = b.stokAwal
			FROM dbo.farmasiMasterObatDetail a	
				 INNER JOIN dbo.farmasiPenghapusanStokDetail b ON a.idObatDetail = b.idObatDetail
			WHERE b.idPenghapusanStok = @idPenghapusanStok;

			/*Menghapus Jurnal Penghapusan Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPenghapusanStokDetail b ON a.idPenghapusanStokDetail = b.idPenghapusanStokDetail
			 WHERE b.idPenghapusanStok = @idPenghapusanStok;

			/*Mengupdate Status Penghapusan*/
			UPDATE dbo.farmasiPenghapusanStok
			   SET idStatusPenghapusan = 1/*Entry Penghapusan*/
				  ,kodePenghapusan = '-'
				  ,tanggalModifikasi = NULL
			 WHERE idPenghapusanStok = @idPenghapusanStok;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Batal Validasi Penghapusan Stok Barang Expired Berhasil' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'ERROR !: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END