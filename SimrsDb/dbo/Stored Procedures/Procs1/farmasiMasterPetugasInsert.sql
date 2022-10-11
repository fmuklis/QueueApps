-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterPetugasInsert] 
	-- Add the parameters for the stored procedure here
	@namaPetugasFarmasi nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS(Select 1 From [dbo].[farmasiMasterPetugas] Where [namaPetugasFarmasi] = @namaPetugasFarmasi)
		Begin
			INSERT INTO [dbo].[farmasiMasterPetugas]
					   ([namaPetugasFarmasi])
				 VALUES
					   (@namaPetugasFarmasi);
			Select 'Data Berhasil Disimpan' as respon, 1 as  responCode;
		End
	ELSE
		Begin
			Select 'Data Sudah Ada' as respon, 0 as  responCode;
		End

END