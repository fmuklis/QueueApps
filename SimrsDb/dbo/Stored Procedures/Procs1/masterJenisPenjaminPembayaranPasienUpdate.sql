-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterJenisPenjaminPembayaranPasienUpdate]
	-- Add the parameters for the stored procedure here
	 @idJenisPenjaminPembayaranPasien int
	,@namaJenisPenjaminPembayaranPasien nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterJenisPenjaminPembayaranPasien] where idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien)
		BEGIN
			UPDATE [dbo].[masterJenisPenjaminPembayaranPasien]
			   SET [namaJenisPenjaminPembayaranPasien] = @namaJenisPenjaminPembayaranPasien
			WHERE idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien;
			SELECT 'Data Berhasil Diubah' as respon, 1 as responCode;
		END
	ELSE
		BEGIN
			SELECT 'Maaf Data Tidak Ditemukan' as respon, 0 as responCode;
		END
END