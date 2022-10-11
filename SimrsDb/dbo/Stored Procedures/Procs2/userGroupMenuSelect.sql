-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		takin788
-- Create date: 05-07-2018
-- Description:	untuk menampilkan menu utama
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[userGroupMenuSelect]
	-- Add the parameters for the stored procedure here
	@idGroupUser int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select distinct a.idMenu,a.namaMenu,a.namaIconMenu,c.menuOrder 
	From masterMenu 
			a inner join masterMenuSub b on a.idMenu = b.idMenu
			inner join masterMenuSubGroupMember c on b.idSubMenu = c.idSubMenu 
	Where c.idGroupUser = @idGroupUser 
	order by c.menuOrder
	
END