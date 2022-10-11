-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorUtdrs]
(
	-- Add the parameters for the function here
	@tanggalHasil date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/UTDRS/'+ dbo.generate_roman(MONTH(@tanggalHasil)) +'/'+ CAST(YEAR(@tanggalHasil) AS varchar(10));

	DECLARE @listNumberUtdrs table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listNumberUtdrs
	     SELECT LEFT(nomorUtdrs, 4)
		   FROM dbo.transaksiOrder
		  WHERE YEAR(tanggalHasil) = YEAR(@tanggalHasil) AND MONTH(tanggalHasil) = MONTH(@tanggalHasil)
				AND LEN(nomorUtdrs) > 4
	   ORDER BY nomorUtdrs DESC;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listNumberUtdrs WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END