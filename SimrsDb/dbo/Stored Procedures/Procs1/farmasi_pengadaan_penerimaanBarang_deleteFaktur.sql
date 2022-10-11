-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menyimpan Data Pembelian Obat
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_deleteFaktur]
	-- Add the parameters for the stored procedure here
    @idPembelianHeader int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPembelian WHERE idPembelianHeader = @idPembelianHeader AND idStatusPembelian <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPembelian a
				   LEFT JOIN dbo.farmasiMasterStatusPembelian b ON a.idStatusPembelian = b.idStatusPembelian
			 WHERE a.idPembelianHeader = @idPembelianHeader;
		END
	ELSE
		BEGIN
			DELETE [dbo].[farmasiPembelian]
			 WHERE idPembelianHeader = @idPembelianHeader;

			SELECT 'Faktur Penerimaan Barang Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END