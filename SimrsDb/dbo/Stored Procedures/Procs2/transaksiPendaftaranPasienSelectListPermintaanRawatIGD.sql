-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectListPermintaanRawatIGD]
	-- Add the parameters for the stored procedure here
	@page int
	,@size int
	,@search nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @offset nvarchar(50)
			,@newsize nvarchar(50)
		   ,@jmlData int = (Select Count(idPendaftaranPasien) From dbo.transaksiPendaftaranPasien xa 
							 Where xa.idStatusPendaftaran = 1 And xa.idJenisPendaftaran = 1 And xa.idJenisPerawatan = 2)
			,@Query NVARCHAR(MAX)
			,@Where NVARCHAR(MAX) = Case
										When @search Is Not Null
											Then 'And (noRM like '''+'%'+@search+'%'' Or namaPasien like '''+'%'+@search+'%'' Or kodePasien like '''+'%'+@search+'%'')'
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
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT * 
				    FROM (SELECT TOP '+ @newsize +' a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, ca.namaJenisPenjaminInduk
								,ROW_NUMBER() OVER (ORDER BY a.tglDaftarPasien) As id
								,Case
									  When Exists(Select 1 From dbo.transaksiTindakanPasien xa Where a.idPendaftaranPasien = xa.idPendaftaranPasien)
										   Then 1
									  Else 0
								  End As flagTindakan
								,'+ Convert(nvarchar(50), @jmlData) +' As jumlahData
							FROM dbo.transaksiPendaftaranPasien a
								 Inner Join dbo.dataPasien() b On a.idPasien = b.idPasien
								 Inner Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
										Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk ca On c.idJenisPenjaminInduk = ca.idJenisPenjaminInduk
						   WHERE a.idStatusPendaftaran = 1 And a.idJenisPendaftaran = 1 And a.idJenisPerawatan = 2 '+ @Where +') As dataSet
					WHERE id Between '+@offset + ' And ' + @newsize +'
				 ORDER BY tglDaftarPasien';
	EXEC(@Query);
END