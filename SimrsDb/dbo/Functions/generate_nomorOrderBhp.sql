-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorOrderBhp]
(
	-- Add the parameters for the function here
	@tanggalOrder date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/FRM-RBHP/'+ dbo.generate_roman(MONTH(@tanggalOrder)) +'/'+ CAST(YEAR(@tanggalOrder) AS varchar(10));

	DECLARE @listNumberOrder table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listNumberOrder
	     SELECT TOP 100 
				LEFT(nomorOrder, 4)
		   FROM dbo.farmasiMutasi
		  WHERE YEAR(tanggalOrder) = YEAR(@tanggalOrder) AND MONTH(tanggalOrder) = MONTH(@tanggalOrder) AND nomorOrder IS NOT NULL
	   ORDER BY nomorOrder DESC;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listNumberOrder WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END