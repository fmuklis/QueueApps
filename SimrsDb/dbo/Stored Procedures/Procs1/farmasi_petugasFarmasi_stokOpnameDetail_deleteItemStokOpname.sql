-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameDetail_deleteItemStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpnameDetail bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idStokOpname bigint = (SELECT idStokOpname FROM dbo.farmasiStokOpnameDetail
									 WHERE idStokOpnameDetail = @idStokOpnameDetail);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname AND idStatusStokOpname <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiStokOpname a
				   LEFT JOIN dbo.farmasiMasterStatusStokOpname b ON a.idStatusStokOpname = b.idStatusStokOpname
			 WHERE a.idStokOpname = @idStokOpname;
		END
	ELSE
		BEGIN
			DELETE [dbo].[farmasiStokOpnameDetail]
			 WHERE [idStokOpnameDetail] = @idStokOpnameDetail;

			SELECT 'Item Tambah / Koreksi Stok Barang Farmasi Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END