-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_imf_entryPenjualanDetail_addItem
	-- Add the parameters for the stored procedure here
	 @idResep bigint
    ,@idUserEntry int
	,@idObatDetail int
	,@idRacikan int
	,@jumlah decimal(18,2)
	,@kaliKonsumsi int
	,@jumlahKonsumsi nvarchar(50)
	,@idTakaran int
	,@idResepWaktu int
	,@keterangan nvarchar(250)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPenjualanHeader bigint
		   ,@idObatDosis int = (Select idObatDosis From dbo.farmasiMasterObatDetail Where idObatDetail = @idObatDetail)
		   ,@idResepDetail bigint
		   ,@idPenjualanDetail bigint;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.farmasiPenjualanHeader Where idResep = @idResep)
		Begin
			INSERT INTO [dbo].[farmasiPenjualanHeader]
					   ([idResep]
					   ,[idStatusPenjualan]
					   ,[idUserEntry])
				 VALUES
					   (@idResep
					   ,1/*Dalam Proses Entri*/
					   ,@idUserEntry);

			/*UPDATE Status Resep*/
			UPDATE dbo.farmasiResep 
			   SET noResep = dbo.noResep('R')
				  ,idStatusResep = 2
			 WHERE idResep = @idResep AND idStatusResep = 1;
		End

	/*GET idPenjualanHeader*/
	Select @idPenjualanHeader = idPenjualanHeader From dbo.farmasiPenjualanHeader Where idResep = @idResep;

	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail And stok < @jumlah)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiPenjualanDetail WHERE idPenjualanHeader = @idPenjualanHeader AND idObatDetail = @idObatDetail)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Sudah Ada Item Resep Yang Sama' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			If Not Exists(Select 1 From dbo.farmasiResepDetail Where idResep = @idResep And idObatDosis = @idObatDosis And idRacikan = 0)
				Begin
					/*INSERT Resep Detail*/
					INSERT INTO [dbo].[farmasiResepDetail]
							   ([idResep]
							   ,[idObatDosis]
							   ,[jumlah]
							   ,[kaliKonsumsi]
							   ,[jumlahKonsumsi]
							   ,[idTakaran]
							   ,[idResepWaktu]
							   ,[keterangan]
							   ,[idUserEntry])
						 VALUES
							   (@idResep
							   ,@idObatDosis
							   ,@jumlah
							   ,@kaliKonsumsi 
							   ,@jumlahKonsumsi
							   ,@idTakaran
							   ,@idResepWaktu
							   ,@keterangan
							   ,@idUserEntry);
				End
			Else
				Begin
					/*UPDATE Resep Detail*/
					UPDATE [dbo].[farmasiResepDetail]
					   SET [jumlah] += @jumlah
					 WHERE idResep = @idResep And idObatDosis = @idObatDosis And idRacikan = 0;
				End

			/*GET idResepDetail*/
			Select @idResepDetail = idResepDetail From dbo.farmasiResepDetail Where idRacikan = 0 And idResep = @idResep And idObatDosis = @idObatDosis;

			/*Add Item Penjualan*/
			INSERT INTO [dbo].[farmasiPenjualanDetail]
					   ([idPenjualanHeader]
					   ,[idObatDetail]
					   ,[idResepDetail]
					   ,[jumlah]
					   ,[hargaPokok]
					   ,[hargaJual])
				 SELECT @idPenjualanHeader
					   ,a.idObatDetail
					   ,@idResepDetail
					   ,@jumlah
					   ,a.hargaPokok
					   ,dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail)
					FROM dbo.farmasiMasterObatDetail a
				   WHERE a.idObatDetail = @idObatDetail;

			/*Get @idPenjualanDetail*/
			SET @idPenjualanDetail = SCOPE_IDENTITY();
			
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
					   ,@idUserEntry
				   FROM dbo.farmasiPenjualanDetail a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
				  WHERE a.idPenjualanDetail = @idPenjualanDetail;

			/*Kurangi Stok Farmasi*/
			UPDATE dbo.farmasiMasterObatDetail
			   SET stok -= @jumlah
			 WHERE idObatDetail = @idObatDetail;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Penjualan Berhasil Disimpan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch
END