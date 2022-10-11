-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_deleteItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idItemPemeriksaanLaboratorium int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.masterLaboratoriumPemeriksaanItemDetail a
						INNER JOIN dbo.transaksiPemeriksaanLaboratorium b ON a.idDetailItemPemeriksaanLaboratorium = b.idDetailItemPemeriksaanLaboratorium
				WHERE a.idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Item Pemeriksaan Telah Digunakan Pada Hasil Pemeriksaan Pasien' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			DELETE dbo.masterLaboratoriumPemeriksaanItem
			 WHERE idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium;

			SELECT 'Item Pemeriksaan Laboratorium Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END