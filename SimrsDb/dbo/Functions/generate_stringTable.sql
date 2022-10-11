-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[generate_stringTable] 
(	
	-- Add the parameters for the function here
	@string nvarchar(max)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	WITH dataSet AS (
		SELECT value
			  ,col = ROW_NUMBER() OVER(ORDER BY (SELECT 1))
		  FROM string_split(@string, '#')
		 WHERE LEN(ISNULL(value,'')) > 0
	) 
	SELECT *
	  FROM dataSet
	 PIVOT (max(value) FOR col IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) resSet
	)