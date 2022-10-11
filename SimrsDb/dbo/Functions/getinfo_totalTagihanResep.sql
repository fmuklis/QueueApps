-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getinfo_totalTagihanResep]
(	
	-- Add the parameters for the function here
	@idBilling bigint

)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT ISNULL(b.totalBiayaResep, 0) - a.diskonTunai - ((ISNULL(b.totalBiayaResep, 0) - a.diskonTunai) * a.diskonPersen / 100) AS nilaiBayar
	  FROM dbo.transaksiBillingHeader a
		   OUTER APPLY (SELECT SUM(xd.jmlHarga) AS totalBiayaResep
						  FROM dbo.farmasiResep xa
							   INNER JOIN dbo.farmasiPenjualanHeader xb ON xa.idResep = xb.idResep
							   INNER JOIN dbo.farmasiPenjualanDetail xc ON xb.idPenjualanHeader = xc.idPenjualanHeader
							   OUTER APPLY dbo.getInfo_biayaPenjualanResep(xc.idPenjualanDetail) xd
						 WHERE (xa.idResep = a.idResep AND xb.idStatusPenjualan = 2/*Siap Bayar*/)
							   OR (xb.idStatusPenjualan = 3/*Dibayar*/ AND xb.idBilling = a.idBilling)) b
	 WHERE a.idBilling = @idBilling
)