-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatSelectForStokOpnameBHPRuangan]
	-- Add the parameters for the stored procedure here
	@idRuangan int
	,@page int
	,@size int
	,@search nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idBHP nvarchar(50) = (Select idBHP From dbo.farmasiBHP Where idRuangan = @idRuangan);

	SET NOCOUNT ON;
    DECLARE @offset nvarchar(50)
		   ,@newsize nvarchar(50)
		   ,@paramDefinition nvarchar(MAX)
		   ,@sql nvarchar(MAX)
		   ,@where nvarchar(MAX) = Case
										When @search Is Null
											 Then ''
										Else 'WHERE namaObat like ''%''+@filter+''%'' Or kodeObat like ''%''+@filter+''%'''
									End;
		If(IsNull(@page, 0) = 0)
			Begin
				SELECT @offset = 1, @newsize = @size;
			End
		Else
			Begin
				SELECT @offset = @page + 1, @newsize = @page + @size;				
			End							  
    -- Insert statements for procedure here
	SET @sql = 'Select *        
				  From (SELECT ROW_NUMBER() OVER (ORDER BY namaObat) AS id             
							  ,ba.idObatDetail, b.idObatDosis, a.kodeObat, dbo.namaBarangFarmasi(b.idObatDosis) As namaObat              
							  ,e.namaJenisObat, c.namaJenisPenjaminInduk, d.namaSatuanObat, ba.tglExpired, ba.stok, ba.hargaPokok
							  , ba.kodeBatch            
							  ,(Select Count(ax.idObat) 
								  From dbo.farmasiMasterObat ax                  
									   Inner Join dbo.farmasiMasterObatDosis bx On ax.idObat = bx.idObat               
									   Left Join dbo.farmasiMasterObatDetail cx On bx.idObatDosis = cx.idObatDosis And idBHP = '+ IsNull(@idBHP, 0) +') As jumlahData
							  ,Case
									When ba.idObatDetail Is Null
										 Then 1
									Else 0
								End As btnSimpan
							  ,Case
									When ba.idObatDetail Is Not Null
										 Then 1
									Else 0
								End As btnTambah
							  ,Case
									When Not Exists(Select 1 From dbo.farmasiPenjualanDetail xa Where ba.idObatDetail = xa.idObatDetail) And ba.idObatDetail Is Not Null
										 And ba.idMetodeStok = 2
										 Then 1
									Else 0
								End As btnHapus
							  ,Case
									When Not Exists(Select 1 From dbo.farmasiPenjualanDetail xa Where ba.idObatDetail = xa.idObatDetail) And ba.idObatDetail Is Not Null
										 And ba.idMetodeStok = 2
										 Then 1
									Else 0
								End As btnEdit
							  ,Case
									When Exists(Select 1 From dbo.farmasiPenjualanDetail xa Where ba.idObatDetail = xa.idObatDetail)
										 Then 1
									Else 0
								End As btnKoreksi																								            
						  FROM dbo.farmasiMasterObat a              
							   Inner Join dbo.farmasiMasterObatDosis b On a.idObat = b.idObat               
							   Left Join dbo.farmasiMasterObatDetail ba On b.idObatDosis = ba.idObatDosis And ba.idBHP = '+ IsNull(@idBHP, 0) +'             
							   Left Join dbo.masterJenisPenjaminPembayaranPasienInduk c On a.idJenisPenjaminInduk = c.idJenisPenjaminInduk      
							   Left Join dbo.farmasiMasterSatuanObat d On a.idSatuanObat = d.idSatuanObat              
							   Left Join dbo.farmasiMasterObatJenis e On a.idJenisObat = e.idJenisOBat @dynamic) As setData      
				 Where id Between '+ @offset +' And '+ @newsize +'';
	SET @sql = Replace(@sql, '@dynamic', @where);
	SET @paramDefinition = N'@filter nvarchar(50)';
	--Select @sql;
	EXEC sp_executesql @sql, @paramDefinition, @filter = @search;
END