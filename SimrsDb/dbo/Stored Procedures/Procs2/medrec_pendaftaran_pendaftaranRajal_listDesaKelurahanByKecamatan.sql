CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listDesaKelurahanByKecamatan]
	@idKecamatan int
AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterDesaKelurahan] a inner join [dbo].[masterKecamatan] b on b.[idKecamatan] = a.[idKecamatan] 
where b.idKecamatan = @idKecamatan order by namaDesaKelurahan asc
END