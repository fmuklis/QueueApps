-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[namaBarangFarmasi](
	-- Add the parameters for the function here
	@idObatDosis int
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(max)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = Replace(c.namaObat + ' ' + Replace(a.dosis, '.00', '') +' '+ Replace(b.namaSatuanDosis, '-', ''), ' 0 ','')
	  FROM dbo.farmasiMasterObatDosis a
		   Left Join dbo.farmasiMasterObatSatuanDosis b On a.idSatuanDosis = b.idSatuanDosis
		   Inner Join dbo.farmasiMasterObat c On a.idObat = c.idObat
	 WHERE a.idObatDosis = @idObatDosis
	-- Return the result of the function
	RETURN @Result
END