-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_nomorPenghapusan]
(
	-- Add the parameters for the function here
	@tanggalPenghapusan date
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suffix varchar(50)
		   ,@counter smallint = 1;

	SELECT @suffix = '/RSUD-OKI/FRM-HPS/'+ dbo.generate_roman(MONTH(@tanggalPenghapusan)) +'/'+ CAST(YEAR(@tanggalPenghapusan) AS varchar(10));

	DECLARE @listPenghapusan table(number smallint);
	-- Add the T-SQL statements to compute the return value here

	INSERT INTO @listPenghapusan
	     SELECT TOP 100 LEFT(kodePenghapusan, 4)
		   FROM dbo.farmasiPenghapusanStok
		  WHERE YEAR(tanggalPenghapusan) = YEAR(@tanggalPenghapusan) AND LEN(kodePenghapusan) > 4
	   ORDER BY kodePenghapusan DESC;

	WHILE EXISTS(SELECT TOP 1 1 FROM @listPenghapusan WHERE number = @counter)
		BEGIN
			SET @counter += 1;
		END

	-- Return the result of the function
	RETURN RIGHT('0000'+ CAST(@counter AS varchar(4)), 4) + @suffix
END