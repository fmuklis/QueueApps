-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpiredDetail_addItemPenghapusan]
	-- Add the parameters for the stored procedure here
	@idObatDetail INT,
	@idPenghapusanStok BIGINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @stokAwal DECIMAL(18,2) = (SELECT stok FROM dbo.farmasiMasterObatDetail WHERE idObatDetail = @idObatDetail) 

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPenghapusanStokDetail WHERE idObatDetail = @idObatDetail AND idPenghapusanStok = @idPenghapusanStok)
		BEGIN
			SELECT 'Data Item Penghapusan Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE 
		BEGIN
			INSERT INTO [dbo].[farmasiPenghapusanStokDetail]
						([idPenghapusanStok]
						,[idObatDetail]
						,[stokAwal])
					VALUES
						(@idPenghapusanStok
						,@idObatDetail
						,@stokAwal)	
			SELECT 'Data Item Penghapusan Berhasil Ditambahkan' AS respon, 1 AS responCode
		END
END