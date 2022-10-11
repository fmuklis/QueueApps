-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterUserUpdatePassword]
	-- Add the parameters for the stored procedure here
	 @idUser int
	,@userPassword nvarchar(32)
	,@userPasswordNew nvarchar(32)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterUser] where [idUser] = @idUser)
		If EXISTS (SELECT 1 from [dbo].[masterUser] where userPassword = @userPassword)
			BEGIN
				UPDATE [dbo].[masterUser]
				   SET userPassword = @userPasswordNew
				 WHERE [idUser] = @idUser;
				SELECT 'Password Berhasil Diubah' as respon, 1 as responCode;
			END
		Else
		Begin
			SELECT 'Password Lama Salah.!' as respon, 0 as responCode;
		End
	ELSE
		BEGIN
			SELECT 'Maaf Data User Tidak Ditemukan' as respon, 0 as responCode;
		END
END