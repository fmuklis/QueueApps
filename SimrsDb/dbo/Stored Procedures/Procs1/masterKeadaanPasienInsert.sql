-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterKeadaanPasienInsert]
	-- Add the parameters for the stored procedure here
	@namaKeadaanPasien nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF not exists (select 1 from [masterKeadaanPasien] where [namaKeadaanPasien] = @namaKeadaanPasien)
		Begin
			INSERT INTO [dbo].[masterKeadaanPasien]
           ([namaKeadaanPasien])
			VALUES
           (@namaKeadaanPasien);
		   select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End
	ELSE 
		Begin
			Select 'Maaf Data Sudah Ada' as respon, 0 as responCode
		End
	
END