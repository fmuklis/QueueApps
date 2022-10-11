-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_entryPenjualan_addItemPenjualanByResep]
	-- Add the parameters for the stored procedure here
	@idResepDetail bigint,
	@idObatDetail bigint,
	@jumlah decimal(18,2),
    @idUserEntry int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPenjualanHeader bigint
		   ,@idPenjualanDetail bigint
		   ,@idResep bigint = (Select idResep From dbo.farmasiResepDetail Where idResepDetail = @idResepDetail);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.farmasiPenjualanHeader Where idResep = @idResep)
		BEGIN
			/*INSERT Data Penjualan Header*/
			INSERT INTO [dbo].[farmasiPenjualanHeader]
					   ([idResep]
					   ,[idStatusPenjualan]
					   ,[idUserEntry])
				 VALUES
					   (@idResep
					   ,1/*Dalam Proses Entri*/
					   ,@idUserEntry);
		END

	/*UPDATE Status Resep*/
	UPDATE dbo.farmasiResep 
	   SET noResep = dbo.noResep('R')
		  ,idStatusResep = 2
	 WHERE idResep = @idResep AND noResep IS NULL;

	/*GET idPenjualanHeader*/
	Select @idPenjualanHeader = idPenjualanHeader From dbo.farmasiPenjualanHeader Where idResep = @idResep;

	/*Cek Stok*/
	If Exists(Select 1 From dbo.farmasiMasterObatDetail Where idObatDetail = @idObatDetail And stok < @jumlah)
		Begin
			Select 'Tidak Dapat Disimpan, Stok Kurang' AS respon, 0 AS responCode;
		End
	/*Cek Jumlah Yg Ditebus*/
	Else If Exists(SELECT 1 
					 FROM dbo.farmasiResepDetail a
						  LEFT JOIN dbo.farmasiPenjualanDetail b ON a.idResepDetail = b.idResepDetail
					WHERE a.idResepDetail = @idResepDetail 
				 GROUP BY a.idResepDetail, a.jumlah
				   HAVING a.jumlah < ISNULL(SUM(b.jumlah), 0) + @jumlah)
		Begin
			Select 'Tidak Dapat Disimpan, Jumlah Obat Melebihi Resep Dokter' As respon, 0 As responCode;
		End
	Else If Exists(Select 1 From dbo.farmasiPenjualanDetail Where idPenjualanHeader = @idPenjualanHeader And idObatDetail = @idObatDetail)
		Begin
			Select 'Tidak Dapat Disimpan, Sudah Ada Data Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*INSERT Penjualan*/
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
						Inner Join dbo.farmasiMasterObatDosis b On a.idobatDosis = b.idobatDosis
				  WHERE a.idObatDetail = @idObatDetail;

			/*GET @idPenjualanDetail*/
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
			SELECT 'Data Penjualan Resep Berhasil Disimpan' AS respon, 1 AS responCode;
		End Try 
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END