CREATE PROCEDURE [dbo].[masterJenisPendaftaranSelectAll]

AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterJenisPendaftaran] order by [namaJenisPendaftaran] asc
END