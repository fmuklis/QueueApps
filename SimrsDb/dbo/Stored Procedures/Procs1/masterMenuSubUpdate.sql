-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterMenuSubUpdate]
	-- Add the parameters for the stored procedure here
	@idSubMenu int
	,@namaSubMenu nvarchar(100)
	,@URL nvarchar(225)
	,@urutan int
	,@namaIconSubMenu nvarchar(25)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.masterMenuSub Where namaSubMenu = @namaSubMenu)
		Begin
			Select 'Gagal!: Sub Menu '+ @namaSubMenu +' Sudah Ada' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[masterMenuSub]
			   SET [namaSubMenu] = @namaSubMenu
				  ,[URL] = @URL
				  ,[urutan] = @urutan
				  ,[namaIconSubMenu] = @namaIconSubMenu
			 WHERE idSubMenu = @idSubMenu

			Select 'Sum Menu Berhasil Diupdate' As respon, 1 As responCode;
		End
END