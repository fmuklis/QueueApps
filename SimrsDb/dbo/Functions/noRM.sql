-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[noRM]
(
	-- Add the parameters for the function here
	--<@Param1, sysname, @p1> <Data_Type_For_Param1, , int>
)
RETURNS nchar(6)
AS
BEGIN
	-- Declare the return variable here
	DECLARE  @status bit = 0
			,@noRmAwal int = 20000
			,@kodePasien nvarchar(10)
			,@mask nchar(6) = '000000'

	-- Add the T-SQL statements to compute the return value here
	WHILE @status = 0
		BEGIN
			If Not Exists (Select 1 From masterPasien Where kodePasien = right(@mask+@kodePasien,6))
				Begin
					Set @status = 1;
					Set @kodePasien = Right(@mask+CAST(@noRmAwal as nvarchar),6)
				End
			Else
				Begin
					Set @noRmAwal = @noRmAwal+1
				End
		END

	-- Return the result of the function
	RETURN @kodePasien
END