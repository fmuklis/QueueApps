-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_mutasi_verifikasiDetail_addItemApproved
	-- Add the parameters for the stored procedure here
	@idItemOrderMutasi bigint,
	@idObatDetail int,
	@jumlahDisetujui decimal(18,2),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMutasi bigint = (SELECT idMutasi FROM dbo.farmasiMutasiOrderItem WHERE idItemOrderMutasi = @idItemOrderMutasi)
		   ,@idMutasiRequestApproved bigint;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi NOT IN(2,3))
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Request Mutasi '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail AND stok < @jumlahDisetujui)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiMutasiRequestApproved WHERE idItemOrderMutasi = @idItemOrderMutasi AND idObatDetail = @idObatDetail)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Sudah Ada Item Yang Sama' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN dbo.farmasiStokOpname b ON a.idStokOpname = b.idStokOpname
					WHERE a.idObatDetail = @idObatDetail AND b.idStatusStokOpname = 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Selesaikan Proses Stok Opname Pada Barang Ini' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1
					 FROM dbo.farmasiMutasiOrderItem a
						  LEFT JOIN dbo.farmasiMutasiRequestApproved b ON a.idItemOrderMutasi = b.idItemOrderMutasi
					WHERE a.idItemOrderMutasi = @idItemOrderMutasi
				 GROUP BY a.idItemOrderMutasi, a.jumlahOrder
				   HAVING a.jumlahOrder < SUM(ISNULL(b.jumlahDisetujui, 0)) + @jumlahDisetujui)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Jumlah Item Melebihi Request' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;
			
			/*Entry Data Barang Yang Disetujui*/
			INSERT INTO [dbo].[farmasiMutasiRequestApproved]
					   ([idItemOrderMutasi]
					   ,[idObatDetail]
					   ,[jumlahDisetujui]
					   ,[idUserEntry])
				 VALUES
					   (@idItemOrderMutasi
					   ,@idObatDetail
					   ,@jumlahDisetujui
					   ,@idUserEntry);

			/*GET idMutasiRequestApproved*/
			SET @idMutasiRequestApproved = SCOPE_IDENTITY();

			/*Membuat Jurnal Stok*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idMutasiRequestApproved]
					   ,[stokAwal]
					   ,[jumlahKeluar]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT a.idObatDetail
					   ,a.idMutasiRequestApproved
					   ,b.stok
					   ,a.jumlahDisetujui
					   ,b.stok - a.jumlahDisetujui
					   ,@idUserEntry
				   FROM dbo.farmasiMutasiRequestApproved a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
				  WHERE a.idMutasiRequestApproved = @idMutasiRequestApproved;

			/*Mengurangi Stok Farmasi*/
			UPDATE a
			   SET a.stok -= ISNULL(b.jumlahDisetujui, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idObatDetail = b.idObatDetail
			 WHERE b.idMutasiRequestApproved = @idMutasiRequestApproved;

			/*Update Status Mutasi BHP*/
			IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi = 2/*Request Divalidasi*/)
				BEGIN
					UPDATE dbo.farmasiMutasi 
					   SET idStatusMutasi = 3/*Proses Verifikasi*/
					 WHERE idMutasi = @idMutasi;
				END

			/*Transaction Commit*/
			COMMIT TRAN;

			SELECT 'Item Verifikasi Request Mutasi Berhasil Disimpan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END