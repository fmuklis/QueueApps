-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[noIMF]
(
	-- Add the parameters for the function here
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Prefix nvarchar(50)
		   ,@counter int
		   ,@data nvarchar(50);

	-- Add the T-SQL statements to compute the return value here
		Set @Prefix = Right('0'+ Convert(nvarchar(2), Month(GetDate())), 2) + Right(Convert(nvarchar(4), Year(GetDate())), 2) +'IMF0000';

		If Not Exists(Select 1 From dbo.farmasiIMF Where Year(tglIMF) = Year(Getdate()) And Month(tglIMF) = Month(GetDate()) And noIMF Is Not Null)
			Begin
				SET @counter = 1
			End
		Else
			Begin
				Select @counter = Convert(int, Right(noIMF, 4)) + 1 
				  From dbo.farmasiIMF 
				 Where idIMF = (Select Max(idIMF)
									From dbo.farmasiIMF
								   Where Year(tglIMF) = Year(Getdate()) And Month(tglIMF) = Month(GetDate()) And noIMF Is Not Null);
			End
		Set @data = Substring(@prefix, 1, Len(@prefix)-Len(@counter)) + Convert(nvarchar(4), @counter);
	-- Return the result of the function
	RETURN @data
END