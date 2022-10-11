-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addHubunganKeluarga]
	-- Add the parameters for the stored procedure here
	@namaHubunganKeluarga nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From [dbo].[masterHubunganKeluarga] Where namaHubunganKeluarga = @namaHubunganKeluarga)
		Begin
			INSERT INTO [dbo].[masterHubunganKeluarga]
					   ([namaHubunganKeluarga])
				 VALUES
					   (@namaHubunganKeluarga);
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Sudah Ada Data Yang Sama' As respon, 0 As responCode;
		End
END