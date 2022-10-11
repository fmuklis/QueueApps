
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameDetail_editItemStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpnameDetail bigint,
	@idObatDosis int,
	@kodeBatch varchar(50),
	@tglExpired date,
	@hargaPokok money,
	@jumlahStokOpname decimal(18,2),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idStokOpname bigint = (SELECT idStokOpname FROM dbo.farmasiStokOpnameDetail
									 WHERE idStokOpnameDetail = @idStokOpnameDetail);
	DECLARE @idJenisStok tinyint = (SELECT idJenisStok FROM dbo.farmasiStokOpname
									 WHERE idStokOpname = @idStokOpname);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatDetail WHERE idJenisStok = @idJenisStok
					 AND idObatDosis = @idObatDosis AND kodeBatch = @kodeBatch)
		BEGIN
			SELECT 'Barang Farmasi Telah Terdaftar, Lakukan Koreksi Stok' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpnameDetail WHERE idStokOpname = @idStokOpname AND idStokOpnameDetail <> @idStokOpnameDetail
						  AND idObatDosis = @idObatDosis AND kodeBatch = @kodeBatch)
		BEGIN
			SELECT 'Item Tambah Stok Barang Telah Terdaftar, Lakukan Koreksi Stok' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname AND idStatusStokOpname <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiStokOpname a
				   LEFT JOIN dbo.farmasiMasterStatusStokOpname b ON a.idStatusStokOpname = b.idStatusStokOpname
			 WHERE a.idStokOpname = @idStokOpname;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[farmasiStokOpnameDetail]
			   SET [idObatDosis] = @idObatDosis
				  ,[kodeBatch] = @kodeBatch
				  ,[tglExpired] = @tglExpired
				  ,[hargaPokok] = @hargaPokok
				  ,[jumlahStokOpname] = @jumlahStokOpname
				  ,[idUserEntry] = @idUserEntry
			 WHERE [idStokOpnameDetail] = @idStokOpnameDetail;

			SELECT 'Data Item Tambah Stok Barang Farmasi Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END