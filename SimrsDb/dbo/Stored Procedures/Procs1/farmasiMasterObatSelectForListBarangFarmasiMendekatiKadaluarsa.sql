-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatSelectForListBarangFarmasiMendekatiKadaluarsa]
	-- Add the parameters for the stored procedure here
	@page int
	,@size int
	,@search nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @jmlData nvarchar(50) = (Select Count(xa.idObat) 
							  From dbo.farmasiMasterObat xa
								   Inner Join dbo.farmasiMasterObatDosis xb On xa.idObat = xb.idObat
								   Inner Join (Select Distinct xc.idObatDosis, xc.kodeBatch, xc.tglExpired, xc.idJenisStok
												 From dbo.farmasiMasterObatDetail xc
												Where xc.stok > = 1) As xc On xb.idObatDosis = xc.idObatDosis
						     Where Convert(Date, xc.tglExpired) < = Convert(Date, DateAdd(Day, xa.jumlahHariPeringatanKadaluarsa , GetDate())))
		   ,@offset nvarchar(50)
		   ,@newsize nvarchar(50)
		   ,@paramDefinition nvarchar(MAX)
		   ,@sql nvarchar(MAX)
		   ,@where NVARCHAR(MAX) = Case
										When @search Is Not Null
											 Then 'And (namaObat like ''%''+@filter+''%'' Or kodeObat like ''%''+@filter+''%'' Or cb.namaJenisStok like ''%''+@filter+''%'')'
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
	SET @sql = 'SELECT c.idObatDosis, dbo.namaBarangFarmasi(c.idObatDosis) As namaObat, ca.kodeBatch, ca.tglExpired
					  ,Sum(ca.stok) As stok, b.namaSatuanObat, cb.namaJenisStok, DateDiff(day, GetDate(), ca.tglExpired) As sisaWaktu
					  ,'+ @jmlData +' As jumlahData
					  ,ROW_NUMBER() OVER (ORDER BY ca.tglExpired) As id
				  FROM dbo.farmasiMasterObat a
					   Inner Join dbo.farmasiMasterSatuanObat b On a.idSatuanObat = b.idSatuanObat
					   Inner Join dbo.farmasiMasterObatDosis c On a.idObat = c.idObat
							Inner Join dbo.farmasiMasterObatDetail ca On c.idObatDosis = ca.idObatDosis
							Inner Join dbo.farmasiMasterObatJenisStok cb On ca.idJenisStok = cb.idJenisStok
				 WHERE Convert(Date, ca.tglExpired) < = Convert(Date, DateAdd(Day, a.jumlahHariPeringatanKadaluarsa , GetDate())) And ca.stok > = 1 @dynamicHere
		      GROUP BY a.namaObat, c.dosis, c.idObatDosis, c.idObatDosis, b.namaSatuanObat, a.stokMinimalGudang, ca.kodeBatch, ca.tglExpired, cb.namaJenisStok
			  ORDER BY ca.tglExpired
			    OFFSET '+ Convert(nvarchar(50), @page) +' ROWS
			FETCH NEXT '+ Convert(nvarchar(50), @size) +' ROWS ONLY';

	SET @sql = Replace(@sql, '@dynamicHere', @where);
	SET @paramDefinition = N'@filter nvarchar(50)';
	EXEC sp_executesql @sql, @paramDefinition, @filter = @search;
END