-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_rincianSementara_listResep]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Resep Obat '+ ca.namaJenisRuangan +', No Resep: '+ ISNULL(COALESCE(a.nomorResep, a.noResep), '-') AS namaResep, SUM(bb.jmlHarga) AS biaya,
			a.tglResep, e.NamaOperator AS DPJP
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
				INNER JOIN dbo.farmasiPenjualanDetail ba ON b.idPenjualanHeader = ba.idPenjualanHeader
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(ba.idPenjualanDetail) bb
		   LEFT JOIN dbo.masterRuangan c On a.idRuangan = c.idRuangan
				LEFT JOIN dbo.masterRuanganJenis ca On c.idJenisRuangan = ca.idJenisRuangan
		   INNER JOIN dbo.masterOperator e ON a.idDokter = e.idOperator
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.idStatusPenjualan = 2/*Siap Bayar*/
  GROUP BY a.nomorResep, a.noResep, ca.namaJenisRuangan, a.tglResep, e.NamaOperator
END