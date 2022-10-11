-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPasienLuarInsertForFarmasiResepPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@nama nvarchar(250),
	@idJenisKelamin int,
	@tglLahir date,
	@alamat nvarchar(250),
	@dokter nvarchar(250),
	@tlp nvarchar(15)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[masterPasienLuar]
			   ([nama]
			   ,[idJenisKelamin]
			   ,[tglLahir]
			   ,[alamat]
			   ,[dokter]
			   ,[tlp]
			   ,[karyawan])
		 VALUES
			   (@nama
			   ,@idJenisKelamin
			   ,@tglLahir
			   ,@alamat
			   ,@dokter
			   ,@tlp
			   ,1/*Karyawan*/);

	Select 'Data Berhasil Disimpan' As respon, 1 As responCode, SCOPE_IDENTITY() As idPasienLuar
END