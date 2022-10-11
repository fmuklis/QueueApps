-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorResep]
(
	-- Add the parameters for the function here
	@tanggalResep date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/FRM-RSP/'+ dbo.generate_roman(MONTH(@tanggalResep)) +'/'+ CAST(YEAR(@tanggalResep) AS varchar(10));

	DECLARE @listNomorResep table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listNomorResep
	     SELECT TOP 200 LEFT(nomorResep, 4)
		   FROM dbo.farmasiResep
		  WHERE tglResep >= CONCAT(LEFT(@tanggalResep, 7), '-01') /*YEAR(tglResep) = YEAR(@tanggalResep) AND MONTH(tglResep) = MONTH(@tanggalResep)*/ AND LEN(nomorResep) > 4
	   ORDER BY nomorResep DESC;

	SELECT @counter = MIN(number)
	  FROM @listNomorResep

	WHILE EXISTS(SELECT TOP 1 1 FROM @listNomorResep WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END