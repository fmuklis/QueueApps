﻿-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_convertBPJSlistPenjamin]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT idJenisPenjaminPembayaranPasien, namaJenisPenjaminPembayaranPasien
	  FROM dbo.masterJenisPenjaminPembayaranPasien
	 WHERE idJenisPenjaminInduk = 2/*BPJS*/
END