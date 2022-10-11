-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_satuanBarang_deleteSatuan] 
	-- Add the parameters for the stored procedure here
	@idSatuanObat int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMasterObat WHERE idSatuanObat = @idSatuanObat)
		BEGIN
			SELECT TOP 1 'Tidak Dapat Dihapus, Satuan Obat Telah Digunakan Pada Nama Barang Faramsi '+ namaObat AS respon, 0 AS responCode
			  FROM dbo.farmasiMasterObat 
			 WHERE idSatuanObat = @idSatuanObat;
		END
	ELSE
		BEGIN
			DELETE dbo.farmasiMasterSatuanObat
			 WHERE idSatuanObat = @idSatuanObat;

			Select 'Data Satuan Barang Farmasi Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END