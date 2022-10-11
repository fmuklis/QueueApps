-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPemakaianInternalBagianInsert]
	-- Add the parameters for the stored procedure here
	@Alias nvarchar(50),
	@namaBagian nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiPemakaianInternalBagian Where namaBagian = @namaBagian)
		Begin
			Select 'Tidak Dapat Disimpan, Sudah Ada Data Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin
			INSERT INTO [dbo].[farmasiPemakaianInternalBagian]
					   ([Alias]
					   ,[namaBagian])
				 VALUES
					   (@Alias
					   ,@namaBagian);

			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
END