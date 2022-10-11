-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_kodeMutasi]
(
	-- Add the parameters for the function here
	@tanggalAprove date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/FRM-MTS/'+ dbo.generate_roman(MONTH(@tanggalAprove)) +'/'+ CAST(YEAR(@tanggalAprove) AS varchar(10));

	DECLARE @listNumberMutasi table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listNumberMutasi
	     SELECT TOP 100 
				LEFT(kodeMutasi, 4)
		   FROM dbo.farmasiMutasi
		  WHERE YEAR(tanggalAprove) = YEAR(@tanggalAprove) AND MONTH(tanggalAprove) = MONTH(@tanggalAprove) AND LEN(kodeMutasi) >= 4
	   ORDER BY kodeMutasi DESC;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listNumberMutasi WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END