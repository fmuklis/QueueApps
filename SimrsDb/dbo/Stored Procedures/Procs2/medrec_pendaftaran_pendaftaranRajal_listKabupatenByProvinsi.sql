CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listKabupatenByProvinsi]
	@idProvinsi int
AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterKabupaten] a inner join [dbo].[masterProvinsi] b on b.[idProvinsi] = a.[idProvinsi]
where b.idProvinsi = @idProvinsi order by a.[namaKabupaten] asc
END