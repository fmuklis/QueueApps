-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatSelectForStokOpname]
	-- Add the parameters for the stored procedure here
	@idRuangan int
	,@page int
	,@size int
	,@search nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok nvarchar(50) = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan);

	SET NOCOUNT ON;
    DECLARE @offset nvarchar(50)
			,@newsize nvarchar(50)
			,@sql NVARCHAR(MAX)
			,@where NVARCHAR(MAX) = Case
										 When @search Is Null
											  Then ''
										 Else 'WHERE namaObat like '''+'%'+@search+'%'' Or kodeObat like '''+'%'+@search+'%'''
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
									   Left Join dbo.farmasiMasterObatDetail cx On bx.idObatDosis = cx.idObatDosis And idJenisStok = '+ IsNull(@idJenisStok, 0) +') As jumlahData
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
									When Not Exists(Select Top 1 1 From dbo.farmasiPenjualanDetail xa Where ba.idObatDetail = xa.idObatDetail) And ba.idObatDetail Is Not Null
										 And ba.idMetodeStok = 2
										 Then 1
									Else 0
								End As btnHapus
							  ,Case
									When Not Exists(Select Top 1 1 From dbo.farmasiPenjualanDetail xa Where ba.idObatDetail = xa.idObatDetail) And ba.idObatDetail Is Not Null
										 And Not Exists(Select Top 1 1 From dbo.farmasiMutasiRequestApproved xa
														 Where ba.idObatDetail = xa.idObatDetail And xa.idStatusMutasi = 3)
										 And ba.idMetodeStok = 2
										 Then 1
									Else 0
								End As btnEdit
							  ,Case
									When Exists(Select Top 1 1 From dbo.farmasiPenjualanDetail xa Where ba.idObatDetail = xa.idObatDetail) 
										 Or Exists(Select Top 1 1 From dbo.farmasiMutasiRequestApproved xa
													Where ba.idObatDetail = xa.idObatDetail  And xa.idStatusMutasi = 3)
										 Or ba.idPembelianDetail is Not Null
										 Or ba.idMetodeStok = 3
										 Then 1
									Else 0
								End As btnKoreksi																								            
						  FROM dbo.farmasiMasterObat a              
							   Inner Join dbo.farmasiMasterObatDosis b On a.idObat = b.idObat               
							   Left Join dbo.farmasiMasterObatDetail ba On b.idObatDosis = ba.idObatDosis And idJenisStok = '+ IsNull(@idJenisStok, 0) +'             
							   Left Join dbo.masterJenisPenjaminPembayaranPasienInduk c On a.idJenisPenjaminInduk = c.idJenisPenjaminInduk      
							   Left Join dbo.farmasiMasterSatuanObat d On a.idSatuanObat = d.idSatuanObat              
							   Left Join dbo.farmasiMasterObatJenis e On a.idJenisObat = e.idJenisOBat '+ @where +') As setData      
				 Where id Between '+ @offset +' And '+ @newsize +''
	EXEC(@sql);
	--Select @sql;
END