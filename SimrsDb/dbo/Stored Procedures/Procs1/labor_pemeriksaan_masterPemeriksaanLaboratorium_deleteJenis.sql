-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_deleteJenis]
	-- Add the parameters for the stored procedure here
	@idJenisPemeriksaanLaboratorium tinyint

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
				WHERE c.idJenisPemeriksaanLaboratorium = @idJenisPemeriksaanLaboratorium)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Jenis Pemeriksaan Telah Digunakan Pada Hasil Pemeriksaan Pasien' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			DELETE FROM [dbo].[masterLaboratoriumPemeriksaanJenis]
			 WHERE idJenisPemeriksaanLaboratorium = @idJenisPemeriksaanLaboratorium;

			SELECT 'Jenis Pemeriksaan Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END