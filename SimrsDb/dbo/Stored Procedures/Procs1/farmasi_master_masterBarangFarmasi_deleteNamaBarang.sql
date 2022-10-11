-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_deleteNamaBarang]
	-- Add the parameters for the stored procedure here
	 @idObat int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMasterObatDosis WHERE idObat = @idObat)
		BEGIN
			SELECT TOP 1 'Tidak Dapat Dihapus, Nama Barang Farmasi Telah Digunakan Pada '+ b.namaBarang AS respon, 0 responCode
			  FROM dbo.farmasiMasterObatDosis a
				   OUTER APPLY dbo.getInfo_barangFarmasi(idObatDosis) b
			 WHERE a.idObat = @idObat;
		END
	ELSE
		BEGIN
			DELETE dbo.farmasiMasterObat
			 WHERE idObat = @idObat;
			
			SELECT 'Data Nama Barang Farmasi Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END