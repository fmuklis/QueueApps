-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_editDetailItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idDetailItemPemeriksaanLaboratorium int,
	@detailItemPemeriksaan varchar(50),
	@satuan nvarchar(50),
	@nilaiRujukan nvarchar(500),
	@nomorUrut tinyint,
	@aktif bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idItemPemeriksaanLaboratorium int = (SELECT idItemPemeriksaanLaboratorium FROM masterLaboratoriumPemeriksaanItemDetail
												   WHERE idDetailItemPemeriksaanLaboratorium = @idDetailItemPemeriksaanLaboratorium);
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanItemDetail WHERE detailItemPemeriksaan = @detailItemPemeriksaan
					 AND idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium AND idDetailItemPemeriksaanLaboratorium <> @idDetailItemPemeriksaanLaboratorium)
		BEGIN
			SELECT 'Tidak Dapat Diedit, Detail Item Pemeriksaan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterLaboratoriumPemeriksaanItemDetail]
			   SET [detailItemPemeriksaan] = @detailItemPemeriksaan
				  ,[satuan] = @satuan
				  ,[nilaiRujukan] = @nilaiRujukan
				  ,[nomorUrut] = @nomorUrut
				  ,[aktif] = @aktif
			 WHERE idDetailItemPemeriksaanLaboratorium = @idDetailItemPemeriksaanLaboratorium;

			IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaanItemDetail
					   WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium AND aktif = 1/*Aktif*/
					GROUP BY idItemPemeriksaanLaboratorium
					  HAVING COUNT(idItemPemeriksaanLaboratorium) > 1)
				BEGIN
					UPDATE dbo.masterLaboratoriumPemeriksaanItem
					   SET multiItem = 1/*Have Multi Result*/
					 WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium;
				END
			ELSE
				BEGIN
					UPDATE dbo.masterLaboratoriumPemeriksaanItem
					   SET multiItem = 0/*Don't Have Multi Result*/
					 WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium;
				END

			SELECT 'Detail Pemeriksaan Laboratorium Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END