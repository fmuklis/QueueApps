CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listKecamatanByKabupaten]

	@idKabupaten int

AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterKecamatan] a inner join [dbo].[masterKabupaten] b on b.[idKabupaten] = a.[idKabupaten]  
where b.[idKabupaten] = @idKabupaten order by [namaKecamatan] asc
END