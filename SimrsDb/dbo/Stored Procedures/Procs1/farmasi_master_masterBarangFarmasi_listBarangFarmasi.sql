-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_listBarangFarmasi]
	-- Add the parameters for the stored procedure here
	@start int,
	@length int,
	@search varchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @persentaseHargaJual tinyint = (SELECT persentaseHargaJualFarmasi FROM dbo.masterKonfigurasi)
		   ,@query nvarchar(MAX)
		   ,@paramDefinition nvarchar(MAX) = '@src varchar(50), @persentaseHarga tinyint'
		   ,@filter nvarchar(MAX) = CASE
										 WHEN LEN(@search) > 3
											  THEN 'WHERE c.namaBarang LIKE ''%''+ @src +''%'' OR bb.namaJenisObat LIKE ''%''+ @src +''%''
													OR ba.namaGolonganObat LIKE ''%''+ @src +''%'' OR bc.kategoriBarang LIKE ''%''+ @src +''%'''
										 ELSE ''
									 END					  
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = '
	WITH srcData AS (
	    SELECT TOP 500 a.idObatDosis, ba.namaGolonganObat, bc.kategoriBarang, bb.namaJenisObat, c.namaBarang
			  ,0 AS hargaJual, c.satuanBarang
		  FROM dbo.farmasiMasterObatDosis a
			   LEFT JOIN dbo.farmasiMasterObat b ON a.idObat = b.idObat
				   LEFT JOIN dbo.farmasiMasterObatGolongan ba ON b.idGolonganObat = ba.idGolonganObat
				   LEFT JOIN dbo.farmasiMasterObatJenis bb ON b.idJenisObat = bb.idJenisOBat
				   LEFT JOIN dbo.farmasiMasterObatKategori bc ON b.idKategoriBarang = bc.idKategoriBarang
			   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
			   /*OUTER APPLY (SELECT MAX(xa.hargaPokok) + (MAX(xa.hargaPokok) * @persentaseHarga / 100) AS hargaJual
							  FROM dbo.farmasiMasterObatDetail xa
							 WHERE xa.idObatDosis = a.idObatDosis AND idJenisStok <> 6/*BHP Ruangan*/
								   AND xa.stok >= 1 AND xa.tglExpired > CAST(GETDATE() AS date)) d*/ #dynamicHere#)

		SELECT *, jumlahData = COUNT(*) OVER()
		  FROM srcData
	  ORDER BY namaBarang
	    OFFSET '+ CAST(@start AS nchar) +' ROWS
	FETCH NEXT '+ CAST(@length AS nchar) +' ROWS ONLY
	';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @persentaseHarga = @persentaseHargaJual, @src = @search;
END