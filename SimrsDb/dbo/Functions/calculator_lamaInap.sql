-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [calculator_lamaInap]
(
	-- Add the parameters for the function here
	@tanggalMasuk date,
	@tanggalKeluar date
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int = 1;

	-- Add the T-SQL statements to compute the return value here
	IF DATEDIFF(DAY, @tanggalMasuk, @tanggalKeluar) > 0
		BEGIN
			SET @result = DATEDIFF(DAY, @tanggalMasuk, @tanggalKeluar);
		END

	-- Return the result of the function
	RETURN @result

END