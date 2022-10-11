-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorPemakaianInternal]
(
	-- Add the parameters for the function here
	@tanggalPermintaan date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/FRM-PI/'+ dbo.generate_roman(MONTH(@tanggalPermintaan)) +'/'+ CAST(YEAR(@tanggalPermintaan) AS varchar(10));

	DECLARE @listPemakaianInternal table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listPemakaianInternal
	     SELECT TOP 100 LEFT(kodePemakaianInternal, 4)
		   FROM dbo.farmasiPemakaianInternal
		  WHERE YEAR(tanggalPermintaan) = YEAR(@tanggalPermintaan) AND MONTH(tanggalPermintaan) = MONTH(@tanggalPermintaan) AND LEN(kodePemakaianInternal) > 4;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listPemakaianInternal WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END