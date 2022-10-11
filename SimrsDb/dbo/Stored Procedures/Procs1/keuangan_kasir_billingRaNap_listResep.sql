-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_listResep]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Resep Obat '+ ca.namaJenisRuangan +', No Resep: '+ ISNULL(a.noResep, '-') AS namaResep, SUM(da.jmlHarga) AS biaya
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
		   LEFT JOIN dbo.masterRuangan c On a.idRuangan = c.idRuangan
				LEFT JOIN dbo.masterRuanganJenis ca On c.idJenisRuangan = ca.idJenisRuangan
				INNER JOIN dbo.farmasiPenjualanDetail ba ON b.idPenjualanHeader = ba.idPenjualanHeader
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(ba.idPenjualanDetail) da
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.idStatusPenjualan = 2/*Siap Bayar*/
  GROUP BY a.noResep, ca.namaJenisRuangan
END