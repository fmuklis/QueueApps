-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDosisSelect]
	-- Add the parameters for the stored procedure here
	@idJenisPenjaminInduk nvarchar(50)
	,@page int
	,@size int
	,@search nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @space nvarchar(50) = ' '
		   ,@replace nvarchar(50) = '.00'
		   ,@replaced nvarchar(50) = '';

    DECLARE @offset nvarchar(50)
			,@newsize nvarchar(50)
			,@where NVARCHAR(MAX) = Case
										When @search Is Not Null
											Then 'WHERE namaObat like '''+'%'+@search+'%'' Or namaJenisObat like '''+'%'+@search+'%'' Or kodeObat like '''+'%'+@search+'%'''
										Else ''
									 End
		If(IsNull(@page, 0) = 0)
			Begin
				SET @offset = 1;
				SET @newsize = @size;
			End
		Else
			Begin
				SELECT @offset = @page + 1, @newsize = @page + @size;				
			End							  

    -- Insert statements for procedure here
	EXEC('Select [idObat], [kodeObat], namaObat, idObatDosis, hargaJual, dosis, namaSatuanDosis, [idJenisObat] 
				,namaJenisObat, idJenisPenjaminInduk, namaJenisPenjaminInduk, [kronis]
				,[idSatuanObat] , namaSatuanObat, stokMinimalGudang, stokMinimalApotik, jumlahHariPeringatanKadaluarsa, jumlahData, id
		    From (SELECT a.[idObat], [kodeObat], Replace([namaObat] +'' ''+ Replace(Convert(Nvarchar(50), f.dosis),''.00'','''') + '' '' + Replace(fa.namaSatuanDosis,''-'',''''),'' 0 '','''') As namaObat, f.idObatDosis, f.hargaJual, f.dosis, fa.namaSatuanDosis, a.[idJenisObat] ,d.namaJenisObat ,a.idJenisPenjaminInduk ,b.namaJenisPenjaminInduk ,a.[kronis]
						,a.[idSatuanObat] ,c.namaSatuanObat,a.stokMinimalGudang,stokMinimalApotik,jumlahHariPeringatanKadaluarsa
						,(Select COUNT(xa.idObat) From dbo.farmasiMasterObat xa
								  Inner Join dbo.farmasiMasterObatDosis xb On xa.idObat = xb.idObat '+ @where+') As jumlahData
						,ROW_NUMBER() OVER (ORDER BY a.namaObat) AS id
					FROM [dbo].[farmasiMasterObat] a
						 Left Join dbo.masterJenisPenjaminPembayaranPasienInduk b On a.idJenisPenjaminInduk = b.idJenisPenjaminInduk
						 Left Join dbo.farmasiMasterSatuanObat c On a.idSatuanObat = c.idSatuanObat
						 Left Join dbo.farmasiMasterObatJenis d On a.idJenisObat = d.idJenisOBat
						 Inner Join dbo.farmasiMasterObatDosis f On a.idObat = f.idObat
							Inner Join dbo.farmasiMasterObatSatuanDosis fa On f.idSatuanDosis = fa.idSatuanDosis '+@where+') a
		  Where id Between '+@offset + ' And ' + @newsize);
END