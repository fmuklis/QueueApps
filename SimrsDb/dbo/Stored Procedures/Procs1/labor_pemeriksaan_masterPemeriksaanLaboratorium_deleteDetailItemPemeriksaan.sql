-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_deleteDetailItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idDetailItemPemeriksaanLaboratorium int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idItemPemeriksaanLaboratorium int = (SELECT idItemPemeriksaanLaboratorium FROM masterLaboratoriumPemeriksaanItemDetail
												   WHERE idDetailItemPemeriksaanLaboratorium = @idDetailItemPemeriksaanLaboratorium);
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.masterLaboratoriumPemeriksaanItemDetail a
						INNER JOIN dbo.transaksiPemeriksaanLaboratorium b ON a.idDetailItemPemeriksaanLaboratorium = b.idDetailItemPemeriksaanLaboratorium
				WHERE a.idDetailItemPemeriksaanLaboratorium = @idDetailItemPemeriksaanLaboratorium)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Detail Pemeriksaan Telah Digunakan Pada Hasil Pemeriksaan Pasien' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			DELETE [dbo].[masterLaboratoriumPemeriksaanItemDetail]
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

			SELECT 'Detail Pemeriksaan Laboratorium Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END