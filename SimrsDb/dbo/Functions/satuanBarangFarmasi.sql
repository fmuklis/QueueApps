-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[satuanBarangFarmasi](
	-- Add the parameters for the function here
	@idObatDosis int
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(max)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = d.namaSatuanObat
	  FROM dbo.farmasiMasterObatDosis a
		   Inner Join dbo.farmasiMasterObat c On a.idObat = c.idObat
		   Inner Join dbo.farmasiMasterSatuanObat d On c.idSatuanObat = d.idSatuanObat
	 WHERE a.idObatDosis = @idObatDosis
	-- Return the result of the function
	RETURN @Result
END