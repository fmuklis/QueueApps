-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternalDetail_addItemPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@idPemakaianInternal bigint,
	@listPemakaianInternal nvarchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @tablePemakaianInternal table(idObatDetail bigint, jumlah decimal(18,2));

	INSERT INTO @tablePemakaianInternal
			   (idObatDetail
			   ,jumlah)
		 SELECT CAST(LEFT(value, CharIndex('#', value) -1) AS bigint)
			   ,CAST(RIGHT(value, CharIndex('#', reverse(value)) -1) AS decimal(18, 2))
		   FROM STRING_SPLIT(@listPemakaianInternal, '|') a
		  WHERE value <> '';

	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMasterObatDetail a INNER JOIN @tablePemakaianInternal b ON a.idObatDetail = b.idObatDetail
			   WHERE ISNULL(a.stok, 0) < ISNULL(b.jumlah, 0))
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN @tablePemakaianInternal b ON a.idObatDetail = b.idObatDetail
					      INNER JOIN dbo.farmasiStokOpname c ON a.idStokOpname = c.idStokOpname
			        WHERE c.idStatusStokOpname = 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Selesaikan Proses Stok Opname' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			DECLARE @listIdPenjualanDetail table(idPenjualanDetail bigint);

			/*Add BHP Tindakan*/
			INSERT INTO [dbo].[farmasiPenjualanDetail]
					   ([idPemakaianInternal]
					   ,[idObatDetail]
					   ,[jumlah]
					   ,[hargaPokok]
					   ,[hargaJual]
					   ,[ditagih]
					   ,[idUserEntry])
				 OUTPUT inserted.idPenjualanDetail
				   INTO @listIdPenjualanDetail		
				 SELECT @idPemakaianInternal
					   ,a.idObatDetail
					   ,b.jumlah
					   ,a.hargaPokok
					   ,dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail)
					   ,0/*Tidak Ditagih*/
					   ,c.idUserEntry
				   FROM dbo.farmasiMasterObatDetail a
						INNER JOIN @tablePemakaianInternal b ON a.idObatDetail = b.idObatDetail AND ISNULL(b.jumlah, 0) > 0
							LEFT JOIN dbo.farmasiPenjualanDetail ba ON b.idObatDetail = ba.idObatDetail AND ba.idPemakaianInternal = @idPemakaianInternal
						OUTER APPLY(SELECT idUserEntry FROM dbo.farmasiPemakaianInternal xa WHERE xa.idPemakaianInternal = @idPemakaianInternal) c
				  WHERE ba.idPenjualanDetail IS NULL;

			/*Add Jurnal Pengeluaran Stok*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idPenjualanDetail]
					   ,[stokAwal]
					   ,[jumlahKeluar]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT a.idObatDetail
					   ,a.idPenjualanDetail
					   ,b.stok
					   ,a.jumlah
					   ,b.stok - a.jumlah
					   ,a.idUserEntry
				   FROM dbo.farmasiPenjualanDetail a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
						INNER JOIN @listIdPenjualanDetail c ON a.idPenjualanDetail = c.idPenjualanDetail;

			/*Mengurangi Stok Barang Farmasi*/
			UPDATE a
			   SET a.stok -= ISNULL(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						INNER JOIN @listIdPenjualanDetail ba ON b.idPenjualanDetail = ba.idPenjualanDetail;

			/*Transaction Commit*/
			COMMIT TRAN;

			/*Respon Sukses*/
			Select 'Item Pemakaian Internal Berhasil Ditambah' As respon, 1 As responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;			
		END CATCH
END