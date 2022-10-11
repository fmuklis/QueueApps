-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_dashboard_listPermintaanRawatUgd]
	-- Add the parameters for the stored procedure here
	@page nchar(50)
	,@size nchar(50)
	,@search nvarchar(50)

WITH EXECUTE AS OWNER
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
	SET @Query = 'SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, c.penjamin AS namaJenisPenjaminInduk 
							,'+ Convert(nvarchar(50), @jmlData) +' As jumlahData, a.idStatusPendaftaran
							FROM dbo.transaksiPendaftaranPasien a
								OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
								OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) c
						   WHERE a.idStatusPendaftaran = 1 And a.idJenisPendaftaran = 1 And a.idJenisPerawatan = 2 '+ @Where +'
				 ORDER BY tglDaftarPasien
				 OFFSET ' + @page + ' ROWS FETCH NEXT ' + @size + ' ROWS ONLY';
	EXEC(@Query);
END