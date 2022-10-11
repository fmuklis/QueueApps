-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorStokOpnameBhp]
(
	-- Add the parameters for the function here
	@tanggalStokOpname date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/FARMA-SOBHP/'+ dbo.generate_roman(MONTH(@tanggalStokOpname)) +'/'+ CAST(YEAR(@tanggalStokOpname) AS varchar(10));

	DECLARE @listStokOpname table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listStokOpname
	     SELECT TOP 100 LEFT(kodeStokOpnameBhp, 4)
		   FROM dbo.farmasiStokOpname
		  WHERE YEAR(tanggalStokOpname) = YEAR(@tanggalStokOpname) AND MONTH(tanggalStokOpname) = MONTH(@tanggalStokOpname) AND LEN(kodeStokOpnameBhp) > 4
	   ORDER BY kodeStokOpnameBhp DESC;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listStokOpname WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END