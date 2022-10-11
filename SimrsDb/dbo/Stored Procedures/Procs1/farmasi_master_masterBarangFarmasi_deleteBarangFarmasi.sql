-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_master_masterBarangFarmasi_deleteBarangFarmasi
	-- Add the parameters for the stored procedure here
	 @idObatDosis int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMasterObatDetail WHERE idObatDosis = @idObatDosis)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Barang Farmasi Memiliki Stok Yang Tidak Dapat Dihapus ' AS respon, 0 responCode;
		END
	ELSE
		BEGIN
			DELETE dbo.farmasiMasterObatDosis
			 WHERE idObatDosis = @idObatDosis;
			
			SELECT 'Data Barang Farmasi Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END