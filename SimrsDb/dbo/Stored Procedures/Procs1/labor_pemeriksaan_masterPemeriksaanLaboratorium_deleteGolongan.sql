-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_deleteGolongan]
	-- Add the parameters for the stored procedure here
	@idGolonganPemeriksaanLaboratorium tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.masterLaboratoriumPemeriksaanItem a
					 INNER JOIN dbo.masterLaboratoriumPemeriksaanItemDetail b ON a.idItemPemeriksaanLaboratorium = b.idItemPemeriksaanLaboratorium
						INNER JOIN dbo.transaksiPemeriksaanLaboratorium ba ON b.idDetailItemPemeriksaanLaboratorium = ba.idDetailItemPemeriksaanLaboratorium
					 INNER JOIN dbo.masterLaboratoriumPemeriksaan c ON a.idPemeriksaanLaboratorium = c.idPemeriksaanLaboratorium
						INNER JOIN dbo.masterLaboratoriumPemeriksaanJenis ca ON c.idJenisPemeriksaanLaboratorium = ca.idJenisPemeriksaanLaboratorium
				WHERE ca.idGolonganPemeriksaanLaboratorium = @idGolonganPemeriksaanLaboratorium)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Golongan Pemeriksaan Telah Digunakan Pada Hasil Pemeriksaan Pasien' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			DELETE dbo.masterLaboratoriumPemeriksaanGolongan
			 WHERE idGolonganPemeriksaanLaboratorium = @idGolonganPemeriksaanLaboratorium;

			SELECT 'Golongan Pemeriksaan Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END