-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menyimpan Data Pembelian Obat
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_editFaktur]
	-- Add the parameters for the stored procedure here
    @idPembelianHeader int,
	@noFaktur varchar(50),
    @tglPembelian date,
    @keterangan varchar(max),
	@tglJatuhTempoPembayaran date,
	@ppn decimal(18,2),
    @idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPembelian WHERE idPembelianHeader = @idPembelianHeader AND idStatusPembelian <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Diedit, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPembelian a
				   LEFT JOIN dbo.farmasiMasterStatusPembelian b ON a.idStatusPembelian = b.idStatusPembelian
			 WHERE a.idPembelianHeader = @idPembelianHeader;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiPembelian WHERE idPembelianHeader <> @idPembelianHeader AND noFaktur = @noFaktur)
		BEGIN
			SELECT 'Nomor Faktur: '+ @noFaktur +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[farmasiPembelian]
			   SET [noFaktur] = @noFaktur
				  ,[tglPembelian] = @tglPembelian
				  ,[userIdEntry] = @idUserEntry
				  ,[keterangan] = @keterangan
				  ,[tglJatuhTempoPembayaran] = @tglJatuhTempoPembayaran
				  ,[ppn] = @ppn
			 WHERE idPembelianHeader = @idPembelianHeader;

			Select 'Faktur Penerimaan Barang Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END