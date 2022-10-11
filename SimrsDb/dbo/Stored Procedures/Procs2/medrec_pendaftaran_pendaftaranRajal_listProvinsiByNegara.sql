CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listProvinsiByNegara]
	@idNegara int
AS
BEGIN
	SET NOCOUNT ON;
select * from  [dbo].[masterNegara] a inner join  [dbo].[masterProvinsi] b on b.[idNegara] = a.[idNegara] where a.[idNegara] = @idNegara order by [namaProvinsi] asc
END