-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanTotalPersediaanFaramsi]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.namaJenisStok, Sum(b.stok) As jmlStok, Sum(b.stok * b.hargaPokok) As nilai
	  FROM dbo.farmasiMasterObatJenisStok a
		   Left Join dbo.farmasiMasterObatDetail b On a.idJenisStok = b.idJenisStok
  GROUP BY a.namaJenisStok
  ORDER BY a.namaJenisStok
END