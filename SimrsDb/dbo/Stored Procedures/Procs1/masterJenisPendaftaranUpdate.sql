-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterJenisPendaftaranUpdate]
	-- Add the parameters for the stored procedure here
	 @idJenisPendaftaran int
	,@namaJenisPendaftaran nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterJenisPendaftaran] where [idJenisPendaftaran] = @idJenisPendaftaran)
		BEGIN
			UPDATE [dbo].[masterJenisPendaftaran]
			SET  [namaJenisPendaftaran] = @namaJenisPendaftaran
			WHERE [idJenisPendaftaran] = @idJenisPendaftaran;
			SELECT 'Data Berhasil Diubah' as respon, 1 as responCode;
		END
	ELSE
		BEGIN
			SELECT 'Maaf Data Tidak Ditemukan' as respon, 0 as responCode;
		END
END