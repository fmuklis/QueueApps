-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_addBHP]
	-- Add the parameters for the stored procedure here
	@idTindakanPasien bigint,
	@listBHP nvarchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @listBHPTindakan table(idObatDetail bigint, jumlah decimal(18,2));

	INSERT INTO @listBHPTindakan
			   (idObatDetail
			   ,jumlah)
		 SELECT CAST(LEFT(value, CharIndex('#', value) -1) AS bigint)
			   ,CAST(RIGHT(value, CharIndex('#', reverse(value)) -1) AS decimal(18, 2))
		   FROM STRING_SPLIT(@listBHP, '|') a
		  WHERE value <> '';

	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMasterObatDetail a INNER JOIN @listBHPTindakan b ON a.idObatDetail = b.idObatDetail
			   WHERE ISNULL(a.stok, 0) < ISNULL(b.jumlah, 0))
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Item BHP Kurang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN @listBHPTindakan b ON a.idObatDetail = b.idObatDetail
					      INNER JOIN dbo.farmasiStokOpname c ON a.idStokOpname = c.idStokOpname
			        WHERE c.idStatusStokOpname = 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Selesaikan Proses Stok Opname BHP Ruangan' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			DECLARE @listIdPenjualanDetail table(idPenjualanDetail bigint);

			/*Add BHP Tindakan*/
			INSERT INTO [dbo].[farmasiPenjualanDetail]
					   ([idTindakanPasien]
					   ,[idObatDetail]
					   ,[jumlah]
					   ,[hargaPokok]
					   ,[hargaJual]
					   ,[ditagih])
				 OUTPUT inserted.idPenjualanDetail
				   INTO @listIdPenjualanDetail		
				 SELECT @idTindakanPasien
					   ,a.idObatDetail
					   ,b.jumlah
					   ,a.hargaPokok
					   ,dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail)
					   ,dbo.verifikasi_penagihanBHP()
				   FROM dbo.farmasiMasterObatDetail a
						INNER JOIN @listBHPTindakan b ON a.idObatDetail = b.idObatDetail AND ISNULL(b.jumlah, 0) > 0
							LEFT JOIN dbo.farmasiPenjualanDetail ba ON b.idObatDetail = ba.idObatDetail AND ba.idTindakanPasien = @idTindakanPasien
				  WHERE ba.idPenjualanDetail IS NULL;

			/*Add Jurnal Stok Keluar*/
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
					   ,d.idUserEntry
				   FROM dbo.farmasiPenjualanDetail a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
						INNER JOIN @listIdPenjualanDetail c ON a.idPenjualanDetail = c.idPenjualanDetail
						INNER JOIN dbo.transaksiTindakanPasien d ON a.idTindakanPasien = d.idTindakanPasien;

			/*Mengurangi Stok BHP Ruangan*/
			UPDATE a
			   SET a.stok -= ISNULL(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						INNER JOIN @listIdPenjualanDetail ba ON b.idPenjualanDetail = ba.idPenjualanDetail;

			/*Transaction Commit*/
			COMMIT TRAN;

			/*Respon Sukses*/
			Select 'BHP Pemeriksaan Labroatorium Berhasil Ditambah' As respon, 1 As responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;			
		END CATCH
END