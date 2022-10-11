﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION getInfo_totalTagihanGawatDarurat
(	
	-- Add the parameters for the function here
	@idBilling bigint

)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT ISNULL(b.totalBiayaPerawatan, 0) + ISNULL(c.totalBiayaBhp, 0) + ISNULL(d.totalBiayaResep, 0)
					  - a.diskonTunai 
					  - ((ISNULL(b.totalBiayaPerawatan, 0) + ISNULL(c.totalBiayaBhp, 0) + ISNULL(d.totalBiayaResep, 0) - a.diskonTunai) * a.diskonPersen / 100) AS nilaiBayar
	  FROM dbo.transaksiBillingHeader a
		   OUTER APPLY (SELECT SUM(xb.jmlTarif) AS totalBiayaPerawatan
						  FROM dbo.transaksiTindakanPasien xa
							   OUTER APPLY dbo.getInfo_tarifTindakan(xa.idTindakanPasien) xb
						 WHERE xa.idPendaftaranPasien = a.idPendaftaranPasien AND xa.idJenisBilling = a.idJenisBilling) b
		   OUTER APPLY (SELECT SUM(xb.jmlTarifBHP) AS totalBiayaBhp
						  FROM dbo.transaksiTindakanPasien xa
							   OUTER APPLY dbo.getInfo_bhpTindakan(xa.idTindakanPasien) xb
						 WHERE xa.idPendaftaranPasien = a.idPendaftaranPasien AND xa.idJenisBilling = a.idJenisBilling) c
		   OUTER APPLY (SELECT SUM(xd.jmlHarga) AS totalBiayaResep
						  FROM dbo.farmasiResep xa
							   INNER JOIN dbo.farmasiPenjualanHeader xb ON xa.idResep = xb.idResep
							   INNER JOIN dbo.farmasiPenjualanDetail xc ON xb.idPenjualanHeader = xc.idPenjualanHeader
							   OUTER APPLY dbo.getInfo_biayaPenjualanResep(xc.idPenjualanDetail) xd
						 WHERE xa.idPendaftaranPasien = a.idPendaftaranPasien AND (xb.idStatusPenjualan = 2/*Siap Bayar*/
							   OR (xb.idStatusPenjualan = 3/*Dibayar*/ AND xb.idBilling = a.idBilling))) d
	 WHERE a.idBilling = @idBilling
)