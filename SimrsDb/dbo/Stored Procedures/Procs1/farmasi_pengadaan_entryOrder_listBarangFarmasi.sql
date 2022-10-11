CREATE PROCEDURE [dbo].[farmasi_pengadaan_entryOrder_listBarangFarmasi]
	-- Add the parameters for the stored procedure here
	@start int,
	@length int,
	@search varchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@srch varchar(50)'
		   ,@filter NVARCHAR(MAX) = Case
										When @search Is Not Null
											Then 'WHERE b.namaObat LIKE ''%''+ @srch +''%'''
										Else ''
									 End

	SET NOCOUNT ON;
    -- Insert statements for procedure here

	SET @query = '
		SELECT a.idObatDosis, b.namaObat, b.satuanBarang
			  ,jumlahData = COUNT(*) OVER()
		  FROM dbo.farmasiMasterObatDosis a
			   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b #dynamicHere#
	  ORDER BY b.namaObat
	  OFFSET '+ CAST(@start AS nchar) +' ROWS
  FETCH NEXT '+ CAST(@length AS nchar) +' ROWS ONLY
	';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @srch = @search;
END