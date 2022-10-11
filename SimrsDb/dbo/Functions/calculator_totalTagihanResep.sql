-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[calculator_totalTagihanResep]
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
	SELECT @hargaJual = ISNULL(b.totalBiayaResep, 0) - a.diskonTunai - ((ISNULL(b.totalBiayaResep, 0) - a.diskonTunai) * a.diskonPersen / 100)
	  FROM dbo.transaksiBillingHeader a
		   OUTER APPLY (SELECT SUM(xd.jmlHarga) AS totalBiayaResep
						  FROM dbo.farmasiResep xa
							   INNER JOIN dbo.farmasiPenjualanHeader xb ON xa.idResep = xb.idResep
							   INNER JOIN dbo.farmasiPenjualanDetail xc ON xb.idPenjualanHeader = xc.idPenjualanHeader
							   OUTER APPLY dbo.getInfo_biayaPenjualanResep(xc.idPenjualanDetail) xd
						 WHERE (xa.idResep = a.idResep AND xb.idStatusPenjualan = 2/*Siap Bayar*/)
							   OR (xb.idStatusPenjualan = 3/*Dibayar*/ AND xb.idBilling = a.idBilling)) b
	 WHERE a.idBilling = @idBilling;

	-- Return the result of the function
	RETURN @hargaJual

END