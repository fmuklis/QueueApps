-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienPivot]
	-- Add the parameters for the stored procedure here
	@tgl1 date,
	@tgl2 date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT ',' + QUOTENAME(namaJenisPerawatan) 
            FROM masterJenisPerawatan
			ORDER BY namaJenisPerawatan
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT  ' + @cols + ' from 
            (SELECT b.namaJenisPerawatan,count(a.idPendaftaranPasien) As Jumlah
			 FROM [dbo].[transaksiPendaftaranPasien] a Inner Join masterJenisPerawatan b On a.idJenisPerawatan = b.idJenisPerawatan
			 where tglDaftarPasien between ' + convert(nvarchar(max),@tgl1) + ' and ' + convert(nvarchar(max),@tgl2) + '
			 GROUP BY b.namaJenisPerawatan
             ) x
            pivot 
            (
                 sum(Jumlah)
                for namaJenisPerawatan in (' + @cols + ')
            ) p '

execute(@query)
END