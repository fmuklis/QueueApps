-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaGolonganPenyakitInsert]
	-- Add the parameters for the stored procedure here
	@golonganPenyakit nvarchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.masterDiagnosaGolonganPenyakit Where golonganPenyakit = @golonganPenyakit)
		Begin
			Select 'Gagal!: Sudah Ada Kategori Penyakit Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin
			INSERT INTO [dbo].[masterDiagnosaGolonganPenyakit]
					   ([golonganPenyakit])
				 VALUES
					   (@golonganPenyakit);

			Select 'Golongan Penyakit Berhasil Disimpan' As respon, 1 As responCode;
		End
END