-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_deletePenghapusanBarang]
	-- Add the parameters for the stored procedure here
	@idPenghapusanStok bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPenghapusanStok WHERE idPenghapusanStok = @idPenghapusanStok AND idStatusPenghapusan = 5 /* Validasi */)
		BEGIN
			SELECT 'Data Tidak Dapat Diubah, '+b.caption AS respon, 0 AS responCode
			FROM dbo.farmasiPenghapusanStok a
				LEFT JOIN dbo.farmasiMasterStatusPenghapusan b ON a.idStatusPenghapusan = b.idStatusPenghapusan
			WHERE a.idPenghapusanStok = @idPenghapusanStok
		END
	ELSE
		BEGIN
			DELETE FROM [dbo].[farmasiPenghapusanStok]
			 WHERE idPenghapusanStok = @idPenghapusanStok

			 SELECT 'Data Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END