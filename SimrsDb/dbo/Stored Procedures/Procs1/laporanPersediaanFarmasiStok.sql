-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPersediaanFarmasiStok]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObatDosis, a.idJenisStok, b.namaJenisStok, Sum(a.stok) As stok, Sum(a.stok * a.hargaPokok) As nilai
	  FROM dbo.farmasiMasterObatDetail a
		   Inner Join dbo.farmasiMasterObatJenisStok b On a.idJenisStok = b.idJenisStok
	 WHERE a.stok > = 1
  GROUP BY a.idObatDosis, a.idJenisStok, b.namaJenisStok
  ORDER BY a.idObatDosis
END