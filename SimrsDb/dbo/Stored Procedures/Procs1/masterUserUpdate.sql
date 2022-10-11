-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterUserUpdate]
	-- Add the parameters for the stored procedure here
	 @idUser int
	,@userName nvarchar(50)
	,@namaLengkap nvarchar(50)
	,@noKaryawan nvarchar(50)
	,@idGroupUser int
	,@noHp nvarchar(50)
	,@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterUser] where [idUser] = @idUser)
		BEGIN
			UPDATE [dbo].[masterUser]
			   SET [userName] = @userName
				  ,[namaLengkap] = @namaLengkap
				  ,[noKaryawan] = @noKaryawan
				  ,[idGroupUser] = @idGroupUser
				  ,[noHp] = @noHp
				  ,[idRuangan] = @idRuangan
			 WHERE [idUser] = @idUser;
			SELECT 'User Berhasil Diupdate' as respon, 1 as responCode;
		END
	ELSE
		BEGIN
			SELECT 'Maaf Data User Tidak Ditemukan' as respon, 0 as responCode;
		END
END