-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatSelectForPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@page int,
	@row int,
	@search nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max)
		   ,@jmlData nvarchar(50) = (Select Count(1) From dbo.farmasiMasterObatDetail Where idJenisStok = 1 And stok > 0)
		   ,@where nvarchar(max) = Case
										When Len(@search) > 1
											 Then ' And a.namaObat Like ''%''+@filter+''%'''
										Else ''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @sql = 'SELECT ca.idObatDetail, ca.kodeBatch, ca.stok , b.namaSatuanObat, '+@jmlData+' As jumlahData
					  ,dbo.namaBarangFarmasi(c.idObatDosis) As namaObat
				  FROM dbo.farmasiMasterObat a
					   Inner Join dbo.farmasiMasterSatuanObat b On a.idSatuanObat = b.idSatuanObat
					   Inner Join dbo.farmasiMasterObatDosis c On a.idObat = c.idObat
							Inner Join dbo.farmasiMasterObatDetail ca On c.idObatDosis = ca.idObatDosis And ca.idJenisStok = 1/*Stok Gudang*/
				 WHERE ca.stok > 0 '+@where+'
			  ORDER BY a.namaObat, tglExpired
			    OFFSET '+Convert(nvarchar(10), @page)+' ROWS
			FETCH NEXT '+Convert(nvarchar(10), @row)+' ROWS ONLY';

	SET @paramDefinition = '@filter nvarchar(50)';

	EXEC sp_executesql @sql, @paramDefinition, @filter = @search;
END