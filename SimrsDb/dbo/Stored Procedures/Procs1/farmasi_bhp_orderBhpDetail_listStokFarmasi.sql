-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhpDetail_listStokFarmasi]
	-- Add the parameters for the stored procedure here
	@idJenisStok int,
	@start nchar(50),
	@length nchar(50),
	@search varchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @query nvarchar(max)
		   ,@jumlahData varchar(50)
		   ,@paramDefinition nvarchar(max) = '@idJenStok int, @find varchar(50)'
		   ,@filter nvarchar(max) = CASE
										 WHEN LEN(@search) > 2
											  THEN 'AND (b.namaBarang LIKE ''%''+ @find +''%'')'
										 ELSE ''
									 END;

	SET NOCOUNT ON;
    -- Insert statements for procedure here

	SET @query = '
		SELECT a.idObatDosis, b.namaBarang, SUM(a.stok) AS stok, b.namaSatuanObat, jumlahData = COUNT(*) OVER()
		  FROM dbo.farmasiMasterObatDetail a
			   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		 WHERE a.idJenisStok = @idJenStok AND a.tglExpired >= CAST(GETDATE() AS date) AND ISNULL(a.stok, 0) > 0 #dynamicHere#
	  GROUP BY a.idObatDosis, b.namaBarang, b.namaSatuanObat
	  ORDER BY b.namaBarang
	    OFFSET '+ @start +' ROWS
	FETCH NEXT '+ @length +' ROWS ONLY';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @idJenStok = @idJenisStok, @find = @search;
END