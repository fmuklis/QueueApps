-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDetailSelectForMutasi]
	-- Add the parameters for the stored procedure here
	@idJenisStok nvarchar(50)
   ,@page int
   ,@size int
   ,@search nvarchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @offset nvarchar(50)
			,@newsize nvarchar(50)
			,@sql NVARCHAR(MAX)
			,@where NVARCHAR(MAX) = (Select Case
												When @search is Not Null
													Then 'And (namaObat like '''+'%'+@search+'%'' Or kodeObat like '''+'%'+@search+'%'')'
											Else ''
									 End);

	If(IsNull(@page, 0) = 0)
		Begin
			SELECT @offset = 1, @newsize = @size;
		End
	Else
		Begin
			SELECT @offset = @page + 1, @newsize = @page + @size;				
		End

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SET @sql = 'SELECT *
				  FROM (SELECT c.namaJenisPenjaminInduk, a.kodeObat, a.idObat, d.namaSatuanObat, ba.kodeBatch, ba.tglExpired
							  ,dbo.namaBarangFarmasi(b.idObatDosis) As namaObat
							  ,ba.idObatDetail, ba.idPembelianDetail ,ba.stok ,ba.tglStokAtauTglBeli
							  ,ROW_NUMBER() OVER (ORDER BY a.namaObat, ba.tglExpired) As id
							  ,(Select Count(idObatDetail) From dbo.farmasiMasterObatDetail xa
									   Inner Join dbo.farmasiMasterObatDosis xb On xa.idObatDosis = xb.idObatDosis
									   Inner Join dbo.farmasiMasterObat xc On xb.idObat = xc.idObat
								 Where idJenisStok = '+ @idJenisStok +' And stok > = 1 '+@where+') As JumlahData
						  FROM dbo.farmasiMasterObat a
							   Inner Join dbo.farmasiMasterObatDosis b On a.idObat = b.idObat
									Inner Join dbo.farmasiMasterObatDetail ba On b.idObatDosis = ba.idObatDosis
							   Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk c On a.idJenisPenjaminInduk = c.idJenisPenjaminInduk
							   Inner Join dbo.farmasiMasterSatuanObat d On a.idSatuanObat = d.idSatuanObat
						 WHERE idJenisStok = '+ @idJenisStok +' And stok > = 1 '+ @where +'
					  GROUP BY b.idObatDosis, ba.idObatDetail, c.namaJenisPenjaminInduk, a.kodeObat, a.idObat, a.namaObat, d.namaSatuanObat, ba.kodeBatch, ba.tglExpired
						      ,ba.idPembelianDetail, ba.stok, ba.tglStokAtauTglBeli) As dataSet
				 WHERE id Between '+@offset+' And '+@newsize+'';
	EXECUTE (@sql);
--	Select @sql;
END