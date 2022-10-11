-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE rajal_perawat_tppri_addBHPDetail
	-- Add the parameters for the stored procedure here
	@idTindakanPasien bigint,
	@idObatDetail bigint,
	@jumlah decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPenjualanDetail bigint;

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail AND ISNULL(stok, 0) < @jumlah)
		Begin
			Select 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode;
		End
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiPenjualanDetail a
					WHERE idTindakanPasien = @idTindakanPasien AND idObatDetail = @idObatDetail)
		BEGIN
			Select 'Tidak Dapat Disimpan, Sudah Ada BHP Yang Sama' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN dbo.farmasiStokOpname b ON a.idStokOpname = b.idStokOpname
					WHERE a.idObatDetail = @idObatDetail AND b.idStatusStokOpname = 1/*Proses Opname*/)
		BEGIN
			SELECT 'BHP Sedang Di Stok Opname, Selesaikan Stok Opname Terlebih Dahulu' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*INSERT BHP*/
			INSERT INTO [dbo].[farmasiPenjualanDetail]
					   ([idTindakanPasien]
					   ,[idObatDetail]
					   ,[jumlah]
					   ,[hargaPokok]
					   ,[hargaJual]
					   ,[ditagih])
				 SELECT @idTindakanPasien
					   ,a.idObatDetail
					   ,@jumlah
					   ,a.hargaPokok
					   ,dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail)
					   ,dbo.verifikasi_penagihanBHP()
				   FROM dbo.farmasiMasterObatDetail a
				  WHERE a.idObatDetail = @idObatDetail;

			/*GET @idPenjualanDetail*/
			SET @idPenjualanDetail = SCOPE_IDENTITY();

			/*Tambah Jurnal Stok Penjualan*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idPenjualanDetail]
					   ,[stokAwal]
					   ,[jumlahKeluar]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT a.idObatDetail
					   ,a.idPenjualanDetail
					   ,c.stok
					   ,a.jumlah
					   ,c.stok - a.jumlah
					   ,b.idUserEntry
				   FROM dbo.farmasiPenjualanDetail a
						INNER JOIN dbo.transaksiTindakanPasien b ON a.idTindakanPasien = b.idTindakanPasien
						INNER JOIN dbo.farmasiMasterObatDetail c ON a.idObatDetail = c.idObatDetail
				  WHERE a.idPenjualanDetail = @idPenjualanDetail;

			/*Kurangi Stok BHP Ruangan*/
			UPDATE a
			   SET a.stok -= ISNULL(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
			 WHERE b.idPenjualanDetail = @idPenjualanDetail;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'BHP Berhasil Ditambah' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;			
		End Catch
END