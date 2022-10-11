-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_editJenis]
	-- Add the parameters for the stored procedure here
	@idJenisPemeriksaanLaboratorium tinyint,
	@idGolonganPemeriksaanLaboratorium tinyint,
	@jenisPemeriksaan varchar(50),
	@nomorUrut tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanJenis a
				WHERE idGolonganPemeriksaanLaboratorium = @idGolonganPemeriksaanLaboratorium AND idJenisPemeriksaanLaboratorium <> @idJenisPemeriksaanLaboratorium
					  AND jenisPemeriksaan = @jenisPemeriksaan)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Jenis Pemeriksaan '+ @jenisPemeriksaan +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterLaboratoriumPemeriksaanJenis]
			   SET [idGolonganPemeriksaanLaboratorium] = @idGolonganPemeriksaanLaboratorium
				  ,[jenisPemeriksaan] = @jenisPemeriksaan
				  ,[nomorUrut] = @nomorUrut
			 WHERE idJenisPemeriksaanLaboratorium = @idJenisPemeriksaanLaboratorium;

			SELECT 'Jenis Pemeriksaan '+ @jenisPemeriksaan +' Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END