-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_addJenis]
	-- Add the parameters for the stored procedure here
	@idGolonganPemeriksaanLaboratorium tinyint,
	@jenisPemeriksaan varchar(50),
	@nomorUrut tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanJenis WHERE idGolonganPemeriksaanLaboratorium = @idGolonganPemeriksaanLaboratorium AND jenisPemeriksaan = @jenisPemeriksaan)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Jenis Pemeriksaan '+ @jenisPemeriksaan +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[masterLaboratoriumPemeriksaanJenis]
					   ([idGolonganPemeriksaanLaboratorium]
					   ,[jenisPemeriksaan]
					   ,[nomorUrut])
				 VALUES
					   (@idGolonganPemeriksaanLaboratorium
					   ,@jenisPemeriksaan
					   ,@nomorUrut);

			SELECT 'Jenis Pemeriksaan '+ @jenisPemeriksaan +' Berhasil Dismipan' AS respon, 1 AS responCode;
		END
END