-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_addItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idPemeriksaanLaboratorium int,
	@itemPemeriksaan varchar(50),
	@nomorUrut tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanItem WHERE idPemeriksaanLaboratorium = @idPemeriksaanLaboratorium AND itemPemeriksaan = @itemPemeriksaan)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Item Pemeriksaan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[masterLaboratoriumPemeriksaanItem]
					   ([idPemeriksaanLaboratorium]
					   ,[itemPemeriksaan]
					   ,[nomorUrut])
				 VALUES
					   (@idPemeriksaanLaboratorium
					   ,@itemPemeriksaan
					   ,@nomorUrut);

			SELECT 'Data Item Pemeriksaan Laboratorium Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END