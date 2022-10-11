-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_editItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idItemPemeriksaanLaboratorium int,
	@itemPemeriksaan varchar(50),
	@nomorUrut tinyint,
	@aktif bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPemeriksaanLaboratorium int = (SELECT idPemeriksaanLaboratorium FROM masterLaboratoriumPemeriksaanItem WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium);
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanItem WHERE itemPemeriksaan = @itemPemeriksaan
					 AND idPemeriksaanLaboratorium = @idPemeriksaanLaboratorium AND idItemPemeriksaanLaboratorium <> @idItemPemeriksaanLaboratorium)
		BEGIN
			SELECT 'Tidak Dapat Diedit, Item Pemeriksaan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterLaboratoriumPemeriksaanItem]
			   SET [itemPemeriksaan] = @itemPemeriksaan
				  ,[nomorUrut] = @nomorUrut
				  ,[aktif] = @aktif
			 WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium;

			SELECT 'Data Pemeriksaan Laboratorium Berhasil Diupdatess' AS respon, 1 AS responCode;
		END
END