-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterSatuanObatInsert]
	-- Add the parameters for the stored procedure here
	 @namaSatuanObat nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF Not Exists (Select 1 From [dbo].[farmasiMasterSatuanObat] Where namaSatuanObat = @namaSatuanObat)
		Begin
			INSERT INTO [dbo].[farmasiMasterSatuanObat]
					   ([namaSatuanObat])
				 VALUES
					   (@namaSatuanObat);
			Select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End
	ELSE
		Begin
			Select 'Data Sudah Ada' as respon, 0 as responCode;
		End
END