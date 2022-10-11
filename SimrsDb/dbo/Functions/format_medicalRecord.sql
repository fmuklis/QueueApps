-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[format_medicalRecord]
(
	-- Add the parameters for the function here
	@medicalRecord varchar(50)
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here

	-- Add the T-SQL statements to compute the return value here

	-- Return the result of the function
	RETURN SUBSTRING(@medicalRecord, 1, 2) +'.'+ SUBSTRING(@medicalRecord, 3, 2) +'.'+ SUBSTRING(@medicalRecord, 5, 2)

END