-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[verifikasi_penagihanBHP]
(
	-- Add the parameters for the function here
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @returnValue bit = 0;
	-- Add the T-SQL statements to compute the return value here

	IF EXISTS(SELECT 1 FROM dbo.masterKonfigurasi WHERE bhpDitagihkan = 1)
		BEGIN
			SET @returnValue = 1;
		END
	-- Return the result of the function

	RETURN @returnValue

END