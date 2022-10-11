-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatJenisInsert]
	-- Add the parameters for the stored procedure here
	@namaJenisObat nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From [dbo].[farmasiMasterObatJenis] Where namaJenisObat = @namaJenisObat)
		Begin
			INSERT INTO [dbo].[farmasiMasterObatJenis]
					   ([namaJenisObat])
				 VALUES
					   (@namaJenisObat);
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Data Sudah Ada' As respon, 0 As responCode;
		End
END