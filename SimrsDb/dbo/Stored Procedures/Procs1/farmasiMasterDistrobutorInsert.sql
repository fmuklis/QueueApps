-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterDistrobutorInsert]
	-- Add the parameters for the stored procedure here
	@namaDistroButor nvarchar(50)
	,@alamat nvarchar(50)
	,@telepon nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists (Select 1 From [dbo].[farmasiMasterDistrobutor] Where [namaDistroButor] = @namaDistroButor)
		Begin
			INSERT INTO [dbo].[farmasiMasterDistrobutor]
					   ([namaDistroButor]
					   ,[alamat]
					   ,[telepon])
				 VALUES
					   (@namaDistroButor
					   ,@alamat
					   ,@telepon);
			Select 'Data Distributor Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else 
		Begin
			Select 'Gagal!: Data Distributor Sudah Ada' As respon, 0 As responCode;	
		End
END