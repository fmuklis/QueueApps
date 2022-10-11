-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorRetur]
(
	-- Add the parameters for the function here
	@tanggalRetur date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/FRM-RET/'+ dbo.generate_roman(MONTH(@tanggalRetur)) +'/'+ CAST(YEAR(@tanggalRetur) AS varchar(10));

	DECLARE @listRetur table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listRetur
	     SELECT TOP 100 LEFT(kodeRetur, 4)
		   FROM dbo.farmasiRetur
		  WHERE YEAR(tanggalRetur) = YEAR(@tanggalRetur) AND LEN(kodeRetur) > 4
	   ORDER BY kodeRetur DESC;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listRetur WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END