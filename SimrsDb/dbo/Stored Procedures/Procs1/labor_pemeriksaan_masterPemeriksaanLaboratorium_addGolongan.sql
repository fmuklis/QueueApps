-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_addGolongan]
	-- Add the parameters for the stored procedure here
	@golonganPemeriksaan varchar(50),
	@nomorUrut tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanGolongan WHERE golonganPemeriksaan = @golonganPemeriksaan)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Golongan Pemeriksaan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO dbo.masterLaboratoriumPemeriksaanGolongan
					   (golonganPemeriksaan
					   ,nomorUrut)
				 VALUES 
				 	   (@golonganPemeriksaan
					   ,@nomorUrut);

			SELECT 'Golongan Pemeriksaan '+ @golonganPemeriksaan +' Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END