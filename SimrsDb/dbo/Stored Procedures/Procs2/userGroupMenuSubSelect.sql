-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		takin788
-- Create date: 05-07-2018
-- Description:	untuk menampilkan sub menu 
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[userGroupMenuSubSelect]
	-- Add the parameters for the stored procedure here
	@idMenu int,
	@idgroupUser int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select a.* 
	From masterMenuSub a
		inner join masterMenuSubGroupMember b on a.idSubMenu = b.idSubMenu
	Where a.idMenu = @idMenu and b.idGroupUser = @idgroupUser
	Order By b.subMenuOrder
	
END