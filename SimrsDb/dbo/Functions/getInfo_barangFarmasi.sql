-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_barangFarmasi]
(	
	-- Add the parameters for the function here
	@idObatDosis int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT Replace(c.namaObat + ' ' + Replace(a.dosis, '.00', '') +' '+ Replace(b.namaSatuanDosis, '-', ''), ' 0 ','') As namaBarang
		  ,ca.namaSatuanObat, ca.namaSatuanObat AS satuanBarang, c.namaObat, a.hargaJual
	  FROM dbo.farmasiMasterObatDosis a
		   Inner Join dbo.farmasiMasterObatSatuanDosis b On a.idSatuanDosis = b.idSatuanDosis
		   Inner Join dbo.farmasiMasterObat c On a.idObat = c.idObat
				Inner Join dbo.farmasiMasterSatuanObat ca On c.idSatuanObat = ca.idSatuanObat
	 WHERE a.idObatDosis = @idObatDosis
)