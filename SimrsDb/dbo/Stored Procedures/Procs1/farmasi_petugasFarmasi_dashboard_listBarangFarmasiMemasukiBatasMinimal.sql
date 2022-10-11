-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_dashboard_listBarangFarmasiMemasukiBatasMinimal]
	-- Add the parameters for the stored procedure here
	@page int
	,@size int
	,@search nvarchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @offset nvarchar(50)
		   ,@newsize nvarchar(50)
		   ,@jmlData nvarchar(50) = (Select Count(xa.idObat) 
									   From dbo.farmasiMasterObat xa
											Inner Join dbo.farmasiMasterObatDosis xb On xa.idObat = xb.idObat
											Inner Join (Select xc.idObatDosis, Sum(stok) As stok
														  From dbo.farmasiMasterObatDetail xc
														 Where xc.idJenisStok = 1/*Gudang Farmasi*/
													  Group By xc.idObatDosis) As xc On xb.idObatDosis = xc.idObatDosis
									  Where xc.stok < = xa.stokMinimalGudang)
		   ,@paramDefinition nvarchar(MAX)
		   ,@sql nvarchar(MAX)
		   ,@where nvarchar(MAX) = Case
										When @search Is Not Null
											Then 'WHERE namaObat like ''%''+@filter+''%'' Or kodeObat like ''%''+@filter+''%'''
										Else ''
									 End
		If(IsNull(@page, 0) = 0)
			Begin
				SELECT @offset = 1, @newsize = @size;
			End
		Else
			Begin
				SELECT @offset = @page + 1, @newsize = @page + @size;				
			End						  

    -- Insert statements for procedure here
	SET @sql = 'SELECT c.idObatDosis, dbo.namaBarangFarmasi(c.idObatDosis) As namaObat, Sum(ca.stok) As stok, b.namaSatuanObat
					  ,'+ @jmlData +'As jumlahData
					  ,ROW_NUMBER() OVER (ORDER BY a.namaObat) As id
				  FROM dbo.farmasiMasterObat a
					   Inner Join dbo.farmasiMasterSatuanObat b On a.idSatuanObat = b.idSatuanObat
					   Inner Join dbo.farmasiMasterObatDosis c On a.idObat = c.idObat
							Inner Join dbo.farmasiMasterObatDetail ca On c.idObatDosis = ca.idObatDosis And ca.idJenisStok = 1/*Gudang Farmasi*/ @dynamicHere
			  GROUP BY a.namaObat, c.idObatDosis, c.idObatDosis, b.namaSatuanObat, a.stokMinimalGudang
			    HAVING Sum(ca.stok) < = a.stokMinimalGudang
			  ORDER BY a.namaObat
			    OFFSET '+ Convert(nvarchar(50), @page) +' ROWS
			FETCH NEXT '+ Convert(nvarchar(50), @size) +' ROWS ONLY';				  ;

	SET @sql = Replace(@sql, '@dynamicHere', @where);
	SET @paramDefinition = N'@filter nvarchar(50)';
	EXEC sp_executesql @sql, @paramDefinition, @filter = @search;
END