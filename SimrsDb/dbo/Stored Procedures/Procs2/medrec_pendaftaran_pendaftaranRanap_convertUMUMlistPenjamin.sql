CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_convertUMUMlistPenjamin]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT idJenisPenjaminPembayaranPasien, namaJenisPenjaminPembayaranPasien
	  FROM dbo.masterJenisPenjaminPembayaranPasien
	 WHERE idJenisPenjaminInduk = 1/*UMUM*/
END