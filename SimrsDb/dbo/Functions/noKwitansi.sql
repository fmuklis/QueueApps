-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[noKwitansi] 
(
	-- Add the parameters for the function here
)
RETURNS nvarchar(10)
AS
BEGIN
	-- Declare the return variable here
	Declare @prefix nvarchar(10) = Right('00' + Convert(nvarchar(2), Month(GetDate())), 2) + Convert(nvarchar(2), Right(Year(GetDate()),2)) + 'K00000'
		   ,@counter int
		   ,@data nvarchar(10);

	-- Add the T-SQL statements to compute the return value here
	If Not Exists(Select 1 From dbo.transaksiBillingHeader Where Year(tanggalEntry) = Year(Getdate()) And Month(tanggalEntry) = Month(GetDate()))
		Begin
			SET @counter = 1
		End
	Else
		Begin
			Select @counter = Convert(int, Right(kodeBayar, 5)) + 1 
			  From dbo.transaksiBillingHeader 
			 Where idBilling = (Select Max(idBilling)
								  From dbo.transaksiBillingHeader 
								 Where Year(tanggalEntry) = Year(Getdate()) And Month(tanggalEntry) = Month(GetDate()));
		End
	Set @data = Substring(@prefix, 1, Len(@prefix)-Len(@counter)) + Convert(nvarchar(5), @counter)
	-- Return the result of the function
	RETURN @data
END