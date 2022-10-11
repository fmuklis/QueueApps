-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorLab]
(
	-- Add the parameters for the function here
	@tanggalSampel date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint;

	SELECT @suffix = '/LAB/RSUD-OKI/'+ dbo.generate_roman(MONTH(@tanggalSampel)) +'/'+ CAST(YEAR(@tanggalSampel) AS varchar(10));

	DECLARE @listNumberLab table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listNumberLab
	     SELECT TOP 100 
				LEFT(nomorLabor, 4)
		   FROM dbo.transaksiOrder
		  WHERE YEAR(tanggalSampel) = YEAR(@tanggalSampel) AND MONTH(tanggalSampel) = MONTH(@tanggalSampel)
				AND LEN(nomorLabor) > 4
	   ORDER BY nomorLabor DESC;

	IF EXISTS(SELECT TOP 1 1 FROM @listNumberLab)
		BEGIN
			SELECT @counter = MIN(number) FROM @listNumberLab
		END
	ELSE
		BEGIN
			SET @counter = 1;
		END

	WHILE EXISTS(SELECT TOP 1 1 FROM @listNumberLab WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END