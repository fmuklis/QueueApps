-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_penjamin]
(	
	-- Add the parameters for the function here
	@idJenisPenjaminPembayaranPasien smallint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idJenisPenjaminInduk, a.namaJenisPenjaminPembayaranPasien As jenisPasien, b.namaJenisPenjaminInduk As penjamin
	  FROM dbo.masterJenisPenjaminPembayaranPasien a
		   INNER JOIN dbo.masterJenisPenjaminPembayaranPasienInduk b On a.idJenisPenjaminInduk = b.idJenisPenjaminInduk
	 WHERE a.idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien
)