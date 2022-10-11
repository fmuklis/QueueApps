CREATE PROCEDURE [dbo].[masterUserGroupSelectAll]

AS
BEGIN

	SET NOCOUNT ON;
		SELECT * FROM [dbo].[masterUserGroup] order by [namaGroupUser] asc
END