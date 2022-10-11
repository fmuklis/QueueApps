-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudangDetail_addItem]
	-- Add the parameters for the stored procedure here
	@idRetur bigint,
	@idObatDetail bigint,
    @jumlahRetur decimal(18,2),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idReturDetail bigint;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiRetur WHERE idRetur = @idRetur AND idStatusRetur <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiRetur a
				   LEFT JOIN dbo.farmasiMasterStatusRetur b ON a.idStatusRetur = b.idStatusRetur
			 WHERE a.idRetur = @idRetur;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiReturDetail WHERE idRetur = @idRetur AND idObatDetail = @idObatDetail)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Sudah Ada Item Retur Yang Sama' AS respon, 0 AS responCode
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail AND stok < @jumlahRetur)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN dbo.farmasiStokOpname c ON a.idStokOpname = c.idStokOpname
			        WHERE c.idStatusStokOpname = 1/*Proses Entry*/ AND a.idObatDetail = @idObatDetail)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Barang Farmasi Dalam Proses Stok Opname' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Add Data Item Request Retur*/
			INSERT INTO [dbo].[farmasiReturDetail]
					   ([idRetur]
					   ,[idObatDetail]
					   ,[jumlahAsal]
					   ,[jumlahRetur]
					   ,[idUserEntry])
				 SELECT @idRetur
					   ,a.idObatDetail
					   ,a.stok
					   ,@jumlahRetur
					   ,@idUserEntry
				   FROM dbo.farmasiMasterObatDetail a
				  WHERE a.idObatDetail = @idObatDetail;

			/*Get idReturDetail*/
			SET @idReturDetail = SCOPE_IDENTITY();

			/*Mengurangi Stok Barang Farmasi*/
			UPDATE dbo.farmasiMasterObatDetail
			   SET stok -= @jumlahRetur
			 WHERE idObatDetail = @idObatDetail;

			/*Add Jurnal Stok Keluar*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idReturDetail]
					   ,[stokAwal]
					   ,[jumlahKeluar]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT a.idObatDetail
					   ,a.idReturDetail
					   ,a.jumlahAsal
					   ,a.jumlahRetur
					   ,a.jumlahAsal - a.jumlahRetur
					   ,@idUserEntry
				   FROM farmasiReturDetail a
				  WHERE a.idReturDetail = @idReturDetail;
			
			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Item Request Retur Kegudang Farmasi Berhasil Disimpan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END