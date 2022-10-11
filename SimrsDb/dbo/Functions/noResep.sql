-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[noResep]
(
	-- Add the parameters for the function here
	@mask nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Prefix nvarchar(50)
		   ,@counter int
		   ,@data nvarchar(50);

	-- Add the T-SQL statements to compute the return value here
		Set @Prefix = Right('0'+ Convert(nvarchar(2), Month(GetDate())), 2) + Right(Convert(nvarchar(4), Year(GetDate())), 2) +'R0000';

		If Not Exists(Select 1 From dbo.farmasiResep Where Year(tanggalEntry) = Year(Getdate()) And Month(tanggalEntry) = Month(GetDate()) And noResep is Not Null)
			Begin
				SET @counter = 1
			End
		Else
			Begin
				Select @counter = Max(Convert(int, Right(noResep, 4))) + 1 
				  From dbo.farmasiResep 
				 Where Year(tanggalEntry) = Year(Getdate()) And Month(tanggalEntry) = Month(GetDate());
			End
		Set @data = Substring(@prefix, 1, Len(@prefix)-Len(@counter)) + Convert(nvarchar(4), @counter);
	-- Return the result of the function
	RETURN @data
END