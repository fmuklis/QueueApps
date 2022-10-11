-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_addBarangFarmasi]
	-- Add the parameters for the stored procedure here
	@idObat int,
	@idSatuanDosis int,
	@dosis decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDosis WHERE idObat = @idObat AND idSatuanDosis = idSatuanDosis AND dosis = @dosis)
		BEGIN
			Select 'Tidak Dapat Disimpan Data Barang Farmasi Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiMasterObatDosis]
					   ([idObat]
					   ,[idSatuanDosis]
					   ,[dosis])
				 VALUES
					   (@idObat
					   ,@idSatuanDosis
					   ,@dosis);
			
			Select 'Data Barang Farmasi Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END