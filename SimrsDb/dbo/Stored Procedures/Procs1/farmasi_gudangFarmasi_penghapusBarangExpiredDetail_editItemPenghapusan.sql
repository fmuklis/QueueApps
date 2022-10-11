-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpiredDetail_editItemPenghapusan]
	-- Add the parameters for the stored procedure here
	@idObatDetail INT,
	@idPenghapusanStokDetail BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @stokAwal DECIMAL(18,2) = (SELECT stok FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail) 

    -- Insert statements for procedure here
	BEGIN
		UPDATE [dbo].[farmasiPenghapusanStokDetail]
			SET [idObatDetail] = @idObatDetail
				,[stokAwal] = @stokAwal
			WHERE idPenghapusanStokDetail = @idPenghapusanStokDetail
		SELECT 'Data Stok Berhasil Diubah' AS respon, 1 AS responCode
	END
END