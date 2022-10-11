-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_listNamaBarang]
	-- Add the parameters for the stored procedure here
	@start int,
	@length int,
	@search varchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DECLARE @query nvarchar(MAX)
		   ,@paramDefinition nvarchar(MAX) = '@src varchar(50)'
		   ,@filter nvarchar(MAX) = CASE
										 WHEN LEN(@search) >= 3
											  THEN 'WHERE a.namaObat LIKE ''%''+ @src +''%'' OR d.namaJenisObat LIKE @src +''%''
													OR b.namaGolonganObat LIKE @src +''%'' OR e.kategoriBarang LIKE @src +''%'''
										 ELSE ''
									 END					  

    -- Insert statements for procedure here
	SET @query = '
		SELECT a.idObat, a.kodeObat, a.namaObat, a.idJenisObat ,d.namaJenisObat, a.idGolonganObat, b.namaGolonganObat AS namaJenisPenjaminInduk
			  ,a.idKategoriBarang, e.kategoriBarang AS kronis, a.idSatuanObat ,c.namaSatuanObat,a.stokMinimalGudang,stokMinimalApotik
			  ,jumlahHariPeringatanKadaluarsa, jumlahData = COUNT(*) OVER()
		  FROM dbo.farmasiMasterObat a
			   LEFT JOIN dbo.farmasiMasterObatGolongan b On a.idGolonganObat = b.idGolonganObat
			   LEFT JOIN dbo.farmasiMasterSatuanObat c On a.idSatuanObat = c.idSatuanObat
			   LEFT JOIN dbo.farmasiMasterObatJenis d On a.idJenisObat = d.idJenisOBat
			   LEFT JOIN dbo.farmasiMasterObatKategori e ON a.idKategoriBarang = e.idKategoriBarang #dynamicHere#
	  ORDER BY a.namaObat
	    OFFSET '+ CAST(@start AS nchar) +' ROWS
	FETCH NEXT '+ CAST(@length AS nchar) +' ROWS ONLY
	';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @src = @search;
END