-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[calculator_totalTagihanRawatInap]
(
	-- Add the parameters for the function here
	@idBilling bigint
)
RETURNS decimal(18, 2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @hargaJual decimal(18,2);

	-- Add the T-SQL statements to compute the return value here
	SELECT @hargaJual = ISNULL(b.totalBiayaPerawatan, 0)
					  + ISNULL(c.totalBiayaBhp, 0)
					  + ISNULL(d.totalBiayaResep, 0)
					  + ISNULL(e.totalBiayaKamarRawatInap, 0)
					  - a.diskonTunai 
					  - ((ISNULL(b.totalBiayaPerawatan, 0)
								+ ISNULL(c.totalBiayaBhp, 0)
								+ ISNULL(d.totalBiayaResep, 0)
								+ ISNULL(e.totalBiayaKamarRawatInap, 0)
								- a.diskonTunai) * a.diskonPersen / 100)
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
		   OUTER APPLY dbo.getInfo_biayaKamarRawatInap(a.idPendaftaranPasien) e
	 WHERE a.idBilling = @idBilling;

	-- Return the result of the function
	RETURN @hargaJual

END