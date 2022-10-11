-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[noRegister]
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
		Set @Prefix = Right('0' + Convert(nvarchar(2), Month(GetDate())), 2) + Right(Convert(nvarchar(4), Year(GetDate())), 2) + 'REG000000';

		If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where Year(tglEntry) = Year(Getdate()) And Month(tglEntry) = Month(GetDate()) And noReg Is Not Null)
			Begin
				SET @counter = 1
			End
		Else
			Begin
				Select @counter = Max(Convert(int, Right(noReg, 6))) + 1 
				  From dbo.transaksiPendaftaranPasien
				 Where Year(tglEntry) = Year(Getdate()) And Month(tglEntry) = Month(GetDate()) And noReg Is Not Null;
			End
		Set @data = Substring(@prefix, 1, Len(@prefix)-Len(IsNull(@counter, 1))) + Convert(nvarchar(6), IsNull(@counter, 1));
	-- Return the result of the function
	RETURN @data
END