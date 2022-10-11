-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[operatorTindakan]
(
	-- Add the parameters for the function here
	@idTindakanPasien int,
	@idMasterKatagoriTarip int

)
RETURNS nvarchar(250)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(250)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = c.NamaOperator
	  FROM dbo.transaksiTindakanPasienDetail a
		   Inner Join dbo.transaksiTindakanPasienOperator b On a.idTindakanPasienDetail = b.idTindakanPasienDetail
		   Inner Join dbo.masterOperator c On b.idOperator = c.idOperator
	 WHERE a.idTindakanPasien = @idTindakanPasien And a.idMasterKatagoriTarip = @idMasterKatagoriTarip
	-- Return the result of the function
	RETURN @Result
END