-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_editGolongan]
	-- Add the parameters for the stored procedure here
	@idGolonganPemeriksaanLaboratorium tinyint,
	@golonganPemeriksaan varchar(50),
	@nomorUrut tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanGolongan WHERE golonganPemeriksaan = @golonganPemeriksaan AND idGolonganPemeriksaanLaboratorium <> @idGolonganPemeriksaanLaboratorium)
		BEGIN
			SELECT 'Tidak Dapat Diedit, Golongan Pemeriksaan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE dbo.masterLaboratoriumPemeriksaanGolongan
			   SET golonganPemeriksaan = @golonganPemeriksaan
				  ,nomorUrut = @nomorUrut
			 WHERE idGolonganPemeriksaanLaboratorium = @idGolonganPemeriksaanLaboratorium;

			SELECT 'Golongan Pemeriksaan '+ @golonganPemeriksaan +' Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END