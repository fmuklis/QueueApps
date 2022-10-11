-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[labor_createBillingVerification]
(
	-- Add the parameters for the function here
	@idOrder bigint
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result bit = 0;

	-- Add the T-SQL statements to compute the return value here
	IF EXISTS(SELECT 1 
				FROM dbo.transaksiOrder a
					 INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
						OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) ba
					 LEFT JOIN dbo.transaksiBillingHeader c ON a.idOrder = c.idOrder
			   WHERE a.idOrder = @idOrder AND b.idJenisPerawatan = 2/*Rawat Jalan*/ AND ba.idJenisPenjaminInduk = 1/*UMUM*/ AND c.idBilling IS NULL)
		BEGIN
			SET @result = 1;
		END

	-- Return the result of the function
	RETURN @result

END