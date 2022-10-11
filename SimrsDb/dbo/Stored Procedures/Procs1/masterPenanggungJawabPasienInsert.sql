CREATE PROCEDURE [dbo].[masterPenanggungJawabPasienInsert]
			@namaPenanggungJawabPasien nvarchar(50)
           ,@alamatPenanggungJawabPasien nvarchar(225)
           ,@noHpPenanggungJawabPasien1 nvarchar(50)
		   ,@idHubunganKeluarga int	   

AS
BEGIN
	SET NOCOUNT ON;
		If not exists(Select 1 from masterPenanggungJawabPasien where namaPenanggungJawabPasien = @namaPenanggungJawabPasien And noHpPenanggungJawabPasien1 = @noHpPenanggungJawabPasien1)
			Begin
				INSERT INTO [dbo].[masterPenanggungJawabPasien]
						   ([idHubunganKeluarga]
						   ,[namaPenanggungJawabPasien]
						   ,[alamatPenanggungJawabPasien]
						   ,[noHpPenanggungJawabPasien1])
					 VALUES
						   (@idHubunganKeluarga
						   ,@namaPenanggungJawabPasien
						   ,@alamatPenanggungJawabPasien
						   ,@noHpPenanggungJawabPasien1);			
							select 'Data Berhasil Disimpan' as respon, 1 as responCode;
			End
END