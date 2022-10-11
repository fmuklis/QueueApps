-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpiredDetail_validasiItemPenghapusan]
	-- Add the parameters for the stored procedure here
	@idPenghapusanStok bigint,
	@idUserEntri int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPenghapusanStok WHERE idPenghapusanStok = @idPenghapusanStok AND idStatusPenghapusan <> 1 /* Valiasi */)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPenghapusanStok a
				   LEFT JOIN dbo.farmasiMasterStatusPenghapusan b ON a.idStatusPenghapusan = b.idStatusPenghapusan
			 WHERE a.idPenghapusanStok = @idPenghapusanStok
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPenghapusanStokDetail WHERE idPenghapusanStok = @idPenghapusanStok)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Penghapusan Belum Dientri' AS respon, 0 AS responCode;
		END
	ELSE 
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/* Membuat Log Pengeluaran Stok*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idPenghapusanStokDetail]
					   ,[stokAwal]
					   ,[jumlahKeluar]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT idObatDetail
					   ,idPenghapusanStokDetail
					   ,stokAwal
					   ,stokAwal
					   ,0
					   ,@idUserEntri
				   FROM dbo.farmasiPenghapusanStokDetail a
			      WHERE idPenghapusanStok = @idPenghapusanStok;

			/*Mengupdate Status Penghapusan*/
			UPDATE dbo.farmasiPenghapusanStok
			   SET idStatusPenghapusan = 5/* Validasi*/
				  ,kodePenghapusan = dbo.generate_nomorPenghapusan(tanggalPenghapusan)
				  ,tanggalModifikasi = GETDATE()
			 WHERE idPenghapusanStok = @idPenghapusanStok;

			/* Mengupdate Stok Barang*/
			UPDATE a  
			   SET a.stok -= b.stokAwal
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenghapusanStokDetail b ON a.idObatDetail = b.idObatDetail
			 WHERE b.idPenghapusanStok = @idPenghapusanStok;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Penghapusan Barang Expired Berhasil Divalidasi' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'ERROR !: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END