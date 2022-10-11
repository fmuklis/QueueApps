-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_columnValueFromString]
(	
	-- Add the parameters for the function here
	@string nvarchar(500)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT value AS columnValue, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS columnId
	  FROM string_split(@string, '#')
	 WHERE value <> ''
)