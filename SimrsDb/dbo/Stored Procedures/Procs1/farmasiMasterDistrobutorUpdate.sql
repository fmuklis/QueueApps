-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterDistrobutorUpdate]
	-- Add the parameters for the stored procedure here
	@idDistrobutor int
	,@namaDistroButor nvarchar(50)
	,@alamat nvarchar(50)
	,@telepon nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiMasterDistrobutor Where namaDistroButor = @namaDistroButor And idDistrobutor <> @idDistrobutor)
		Begin
			Select 'Gagal!: Distributor '+ @namaDistroButor +' Sudah Ada' As respon ,0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[farmasiMasterDistrobutor]
			   SET [namaDistroButor] = @namaDistroButor
				  ,[alamat] = @alamat
				  ,[telepon] = @telepon
			 WHERE idDistrobutor = @idDistrobutor;
			Select 'Data Ditributor Berhasil Diupdate' As respon ,1 As responCode;
		End
END