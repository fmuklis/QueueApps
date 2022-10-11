CREATE PROCEDURE [dbo].[masterPasienSelectAll]

AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterPasien] order by [kodePasien] asc
END