-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterJenisTarifUpdate]
	-- Add the parameters for the stored procedure here
	 @idJenisTarif int
	,@namaJenisTarif nvarchar(50)
	,@captionLaporan nvarchar(50)
	,@idJenisPendaftaran int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterJenisTarif] where [idJenisTarif] = @idJenisTarif)
		BEGIN
			UPDATE [dbo].[masterJenisTarif]
			   SET [namaJenisTarif] = @namaJenisTarif
				  ,[captionLaporan] = @captionLaporan
				  ,[idJenisPendaftaran] = @idJenisPendaftaran
			 WHERE [idJenisTarif] = @idJenisTarif;
			SELECT 'Data Berhasil Diubah' as respon, 1 as responCode;
		END
	ELSE
		BEGIN
			SELECT 'Maaf Data Tidak Ditemukan' as respon, 0 as responCode;
		END
END