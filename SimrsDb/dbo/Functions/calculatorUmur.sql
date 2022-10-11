-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[calculatorUmur]
(
	-- Add the parameters for the function here
	@tglLahir date,
	@tglDaftar date
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = Case 
						  When DATEDIFF(hour, @tglLahir, @tglDaftar) / 168 = 0
							   Then Convert(nvarchar(50), DATEDIFF(hour, @tglLahir, @tglDaftar) / 24) + ' Hari'
						  When DATEDIFF(hour, @tglLahir, @tglDaftar) / 730 = 0 
							   Then Convert(nvarchar(50),  DATEDIFF(hour,@tglLahir, @tglDaftar) /168) + ' Minggu'
						  When DATEDIFF(hour, @tglLahir, @tglDaftar) / 8766 = 0 
							   Then Convert(nvarchar(50), DATEDIFF(hour,@tglLahir, @tglDaftar) / 730) + ' Bulan'
						  Else Convert(nvarchar(50), DATEDIFF(hour, @tglLahir, @tglDaftar) /8766) + ' Tahun'
					  End
	-- Return the result of the function
	RETURN @Result
END