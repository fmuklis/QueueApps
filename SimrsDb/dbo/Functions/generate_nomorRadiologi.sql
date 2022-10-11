-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorRadiologi]
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

	SELECT @suffix = '/RSUD-OKI/RAD/'+ dbo.generate_roman(MONTH(@tanggalHasil)) +'/'+ CAST(YEAR(@tanggalHasil) AS varchar(10));

	DECLARE @listNumberRadio table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listNumberRadio
	     SELECT LEFT(nomorRadiologi, 4)
		   FROM dbo.transaksiOrder
		  WHERE YEAR(tanggalHasil) = YEAR(@tanggalHasil) AND MONTH(tanggalHasil) = MONTH(@tanggalHasil)
				AND LEN(nomorRadiologi) > 4
	   ORDER BY nomorRadiologi DESC;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listNumberRadio WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END