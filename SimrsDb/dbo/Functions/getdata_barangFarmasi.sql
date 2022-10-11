-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create FUNCTION [dbo].[getdata_barangFarmasi]
(	
	-- Add the parameters for the function here
	@idObatDosis int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT Replace(c.namaObat + ' ' + Replace(a.dosis, '.00', '') +' '+ Replace(b.namaSatuanDosis, '-', ''), ' 0 ','') As namaBarang, ca.namaSatuanObat
		  ,a.hargaJual
	  FROM dbo.farmasiMasterObatDosis a
		   Left Join dbo.farmasiMasterObatSatuanDosis b On a.idSatuanDosis = b.idSatuanDosis
		   Inner Join dbo.farmasiMasterObat c On a.idObat = c.idObat
				Inner Join dbo.farmasiMasterSatuanObat ca On c.idSatuanObat = ca.idSatuanObat
	 WHERE a.idObatDosis = @idObatDosis
)