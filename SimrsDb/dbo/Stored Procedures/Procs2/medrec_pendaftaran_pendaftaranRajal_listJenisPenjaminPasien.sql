-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listJenisPenjaminPasien]
	-- Add the parameters for the stored procedure here
	@idJenisPenjaminInduk int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idJenisPenjaminPembayaranPasien, namaJenisPenjaminPembayaranPasien 
	  FROM dbo.masterJenisPenjaminPembayaranPasien
	 WHERE idJenisPenjaminInduk = @idJenisPenjaminInduk
  ORDER BY namaJenisPenjaminPembayaranPasien
END