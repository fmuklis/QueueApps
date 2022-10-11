CREATE PROCEDURE [dbo].[masterJenisTarifSelectAll]

AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterJenisTarif] a inner join [dbo].[masterJenisPendaftaran] b on b.[idJenisPendaftaran] = a.[idJenisPendaftaran] order by [namaJenisTarif] asc
END