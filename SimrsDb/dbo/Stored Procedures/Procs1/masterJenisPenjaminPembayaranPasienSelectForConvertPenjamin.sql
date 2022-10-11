-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterJenisPenjaminPembayaranPasienSelectForConvertPenjamin]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisPenjaminInduk int = (Select b.idJenisPenjaminInduk From dbo.transaksiPendaftaranPasien a
												Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
										  Where idPendaftaranPasien = @idPendaftaranPasien);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idJenisPenjaminPembayaranPasien, namaJenisPenjaminPembayaranPasien
	  FROM dbo.masterJenisPenjaminPembayaranPasien 
	 WHERE idJenisPenjaminInduk <> @idJenisPenjaminInduk
END