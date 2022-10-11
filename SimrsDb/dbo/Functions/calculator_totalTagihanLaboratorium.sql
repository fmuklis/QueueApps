-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[calculator_totalTagihanLaboratorium]
(
	-- Add the parameters for the function here
	@idBilling bigint
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @hargaJual int;

	-- Add the T-SQL statements to compute the return value here
	SELECT @hargaJual = ISNULL(b.totalBiayaPemeriksaan, 0) + ISNULL(c.totalBiayaBhp, 0) - a.diskonTunai 
					  - ((ISNULL(b.totalBiayaPemeriksaan, 0) + ISNULL(c.totalBiayaBhp, 0) - a.diskonTunai) * a.diskonPersen / 100)
	  FROM dbo.transaksiBillingHeader a
		   OUTER APPLY (SELECT SUM(xb.jmlTarif) AS totalBiayaPemeriksaan
						  FROM dbo.transaksiTindakanPasien xa
							   OUTER APPLY dbo.getInfo_tarifTindakan(xa.idTindakanPasien) xb
							   INNER JOIN dbo.transaksiOrderDetail xc ON xa.idOrderDetail = xc.idOrderDetail
						 WHERE xc.idOrder = a.idOrder) b
		   OUTER APPLY (SELECT SUM(xb.jmlTarifBHP) AS totalBiayaBhp
						  FROM dbo.transaksiTindakanPasien xa
							   OUTER APPLY dbo.getInfo_bhpTindakan(xa.idTindakanPasien) xb
							   INNER JOIN dbo.transaksiOrderDetail xc ON xa.idOrderDetail = xc.idOrderDetail
						 WHERE xc.idOrder = a.idOrder) c
	 WHERE a.idBilling = @idBilling;

	-- Return the result of the function
	RETURN @hargaJual

END