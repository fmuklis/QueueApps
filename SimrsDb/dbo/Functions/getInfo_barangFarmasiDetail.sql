-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_barangFarmasiDetail]
(	
	-- Add the parameters for the function here
	@idObatDosis int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT REPLACE(c.namaObat + ' ' + REPLACE(a.dosis, '.00', '') +' '+ REPLACE(b.namaSatuanDosis, '-', ''), ' 0 ','') AS namaBarang
		  ,ca.namaSatuanObat AS satuanBarang, a.hargaJual
		  ,CASE
				WHEN c.idKategoriBarang = 2/*Kronis*/
					 THEN cb.kategoriBarang
				WHEN c.idKategoriBarang = 3/*Kemoterapi*/
					 THEN cb.kategoriBarang
				ELSE 'Obat'
			END AS kategoriBarang
		  ,CASE
				WHEN c.idKategoriBarang = 2/*Kronis*/
					 THEN 14
				WHEN c.idKategoriBarang = 3/*Kemoterapi*/
					 THEN 15
				ELSE 13
			END AS kategoriBarangOrder
		  ,CASE
				WHEN c.idKategoriBarang = 2/*Kronis*/
					 THEN 15
				WHEN c.idKategoriBarang = 3/*Kemoterapi*/
					 THEN 16
				ELSE 14
			END AS idMasterTarifGroup
	  FROM dbo.farmasiMasterObatDosis a
		   LEFT JOIN dbo.farmasiMasterObatSatuanDosis b On a.idSatuanDosis = b.idSatuanDosis
		   INNER JOIN dbo.farmasiMasterObat c On a.idObat = c.idObat
				LEFT JOIN dbo.farmasiMasterSatuanObat ca On c.idSatuanObat = ca.idSatuanObat
				LEFT JOIN dbo.farmasiMasterObatKategori cb ON c.idKategoriBarang = cb.idKategoriBarang
	 WHERE a.idObatDosis = @idObatDosis
)