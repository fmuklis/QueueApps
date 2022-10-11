-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_laporan_kunjunganPasien_listPenjamin]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 0 AS idJenisPenjaminInduk, 'SEMUA' AS namaJenisPenjaminInduk
	 UNION ALL
	SELECT idJenisPenjaminInduk, namaJenisPenjaminInduk
	  FROM dbo.masterJenisPenjaminPembayaranPasienInduk
END