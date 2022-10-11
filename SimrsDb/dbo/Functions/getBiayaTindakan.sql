-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getBiayaTindakan]
(
	-- Add the parameters for the function here
	@idTindakanPasien int
)
RETURNS numeric(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result numeric(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = Sum(a.nilai)
	  FROM dbo.transaksiTindakanPasienDetail a
	 WHERE a.idTindakanPasien = @idTindakanPasien
	-- Return the result of the function
	RETURN @Result
END