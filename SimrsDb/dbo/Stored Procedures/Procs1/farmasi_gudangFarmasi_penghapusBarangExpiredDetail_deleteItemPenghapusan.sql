-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpiredDetail_deleteItemPenghapusan]
	-- Add the parameters for the stored procedure here
	@idPenghapusanStokDetail BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 
				FROM dbo.farmasiPenghapusanStokDetail a
					LEFT JOIN dbo.farmasiPenghapusanStok b ON a.idPenghapusanStok = b.idPenghapusanStok 
				WHERE idPenghapusanStokDetail = @idPenghapusanStokDetail AND b.idStatusPenghapusan = 5)
		BEGIN
			SELECT 'Data Tidak Dapat Dihapus, '+ c.caption AS respon, 0 AS responCode
			FROM dbo.farmasiPenghapusanStokDetail a
				LEFT JOIN dbo.farmasiPenghapusanStok b ON a.idPenghapusanStok = b.idPenghapusanStok
				LEFT JOIN dbo.farmasiMasterStatusPenghapusan c ON b.idStatusPenghapusan = c.idStatusPenghapusan
			WHERE a.idPenghapusanStokDetail = @idPenghapusanStokDetail
		END
	ELSE
		BEGIN
			DELETE FROM [dbo].[farmasiPenghapusanStokDetail] WHERE idPenghapusanStokDetail = @idPenghapusanStokDetail
			SELECT 'Data Stok Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END