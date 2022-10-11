-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editHubunganKeluarga]
	-- Add the parameters for the stored procedure here
	 @idHubunganKeluarga int
	,@namaHubunganKeluarga nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.masterHubunganKeluarga Where namaHubunganKeluarga = @namaHubunganKeluarga)
		Begin
			Select 'Tidak Dapat Diupdate, Sudah Ada Hubungan Keluarga Yang Sama' As respon, 0 As responCode;
		End
	Else If Not Exists(Select 1 From dbo.masterHubunganKeluarga Where idHubunganKeluarga = @idHubunganKeluarga)
		Begin
			SELECT 'Maaf Data Tidak Ditemukan' as respon, 0 as responCode;
		End
	Else
		Begin
			UPDATE [dbo].[masterHubunganKeluarga]
			   SET  [namaHubunganKeluarga] = @namaHubunganKeluarga
			 WHERE [idHubunganKeluarga] = @idHubunganKeluarga;
			SELECT 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
END