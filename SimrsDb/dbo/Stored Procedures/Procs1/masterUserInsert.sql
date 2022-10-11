CREATE PROCEDURE [dbo].[masterUserInsert]
	@userName nvarchar(25)
	,@namaLengkap nvarchar(50)
	,@noKaryawan nvarchar(50)
	,@idGroupUser int
	,@userPassword nvarchar(32)
	,@noHp nvarchar(50)
	,@idRuangan int

AS
BEGIN
	SET NOCOUNT ON;
		if  not exists (select 1 from [dbo].[masterUser] where [userName] = @userName)
		begin
			INSERT INTO [dbo].[masterUser]
           ([userName]
           ,[namaLengkap]
           ,[noKaryawan]
           ,[idGroupUser]
           ,[userPassword]
           ,[noHp]
           ,[idRuangan])
     VALUES
           (@userName
			,@namaLengkap
			,@noKaryawan
			,@idGroupUser
			,@userPassword
			,@noHp
			,@idRuangan);
			select 'Akun Berhasil Disimpan' as respon, 1 as responCode;
		end
		else
		begin
			select 'Maaf User Sudah Ada' as respon, 0 as responCode;
		end
END