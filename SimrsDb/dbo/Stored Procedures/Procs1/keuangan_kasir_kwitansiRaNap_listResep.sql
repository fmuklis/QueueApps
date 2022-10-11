-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiRaNap_listResep]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tglResep, 'Resep Obat '+ da.namaJenisRuangan +', No Resep: '+ ISNULL(a.noResep, '-') AS namaResep, SUM(bb.jmlHarga) AS biaya
		  ,e.NamaOperator AS DPJP
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.farmasiPenjualanHeader b ON a.idResep = b.idResep And b.idBilling = @idBilling
				INNER JOIN dbo.farmasiPenjualanDetail ba ON b.idPenjualanHeader = ba.idPenjualanHeader
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(ba.idPenjualanDetail) bb
		   LEFT JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan
				LEFT JOIN dbo.masterRuanganJenis da ON d.idJenisRuangan = da.idJenisRuangan
		   LEFT JOIN dbo.masterOperator e ON a.idDokter = e.idOperator
  GROUP BY a.tglResep, a.noResep, da.namaJenisRuangan, e.NamaOperator
END