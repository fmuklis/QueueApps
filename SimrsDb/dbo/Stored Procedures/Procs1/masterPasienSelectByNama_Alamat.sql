CREATE PROCEDURE [dbo].[masterPasienSelectByNama&Alamat]

	 @namaLengkapPasien nvarchar(100) = null
	,@tglDaftarPasien1 date

AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterPasien] a
	inner join [dbo].[masterJenisKelamin] b on b.[idJenisKelamin] = a.[idJenisKelaminPasien]
order by [kodePasien] asc
END