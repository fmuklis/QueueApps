-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterPabrikInsert]
	-- Add the parameters for the stored procedure here
	@namaPabrik nvarchar(250)
	,@alamatPabrik nvarchar(max)
	,@telp nvarchar(50)
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiMasterPabrik Where namaPabrik = @namaPabrik)
		Begin
			Select 'Gagal, Nama Principal ' +@namaPabrik+ ' Sudah Ada' As respon, 0 As responCode; 
		End
	Else
		Begin
			INSERT INTO [dbo].[farmasiMasterPabrik]
					   ([namaPabrik]
					   ,[alamatPabrik]
					   ,[telp])
				 VALUES
					   (@namaPabrik
					   ,@alamatPabrik
					   ,@telp);
			Select 'Data Principal Berhasil Disimpan' As respon, 1 As responCode; 
		End
END