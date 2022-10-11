-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_addDetailItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idItemPemeriksaanLaboratorium int,
	@detailItemPemeriksaan varchar(50),
	@satuan nvarchar(50),
	@nilaiRujukan nvarchar(500),
	@nomorUrut tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanItemDetail
			   WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium
					 AND detailItemPemeriksaan = @detailItemPemeriksaan)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Detail Item Pemeriksaan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanItemDetail
					   WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium AND aktif = 1)
				BEGIN
					UPDATE dbo.masterLaboratoriumPemeriksaanItem
					   SET multiItem = 1
					 WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium;
				END

			INSERT INTO [dbo].[masterLaboratoriumPemeriksaanItemDetail]
					   ([idItemPemeriksaanLaboratorium]
					   ,[detailItemPemeriksaan]
					   ,[satuan]
					   ,[nilaiRujukan]
					   ,[nomorUrut])
				 VALUES
					   (@idItemPemeriksaanLaboratorium
					   ,@detailItemPemeriksaan
					   ,@satuan
					   ,@nilaiRujukan
					   ,@nomorUrut);

			SELECT 'Detail Item Pemeriksaan Laboratorium Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END