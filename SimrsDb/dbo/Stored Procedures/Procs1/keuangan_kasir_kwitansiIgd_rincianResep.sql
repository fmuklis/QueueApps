-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiIgd_rincianResep]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Resep '+ cc.namaJenisRuangan +' No Resep: '+ ISNULL(c.noResep, '-') AS namaResep
		  ,ca.NamaOperator AS DPJP, cb.namaRuangan, ba.namaBarang, ba.hargaJual
		  ,b.jumlah, ba.satuanBarang, ba.jmlHarga
	  FROM dbo.farmasiPenjualanHeader a
		   INNER JOIN dbo.farmasiPenjualanDetail b On a.idPenjualanHeader = b.idPenjualanHeader
				Outer Apply dbo.getInfo_biayaPenjualanResep(b.idPenjualanDetail) ba
		   LEFT JOIN dbo.farmasiResep c ON a.idResep = c.idResep
				Inner Join dbo.masterOperator ca On c.idDokter = ca.idOperator
				Inner Join dbo.masterRuangan cb On c.idRuangan = cb.idRuangan
				Inner Join dbo.masterRuanganJenis cc On cb.idJenisRuangan = cc.idJenisRuangan
	 WHERE a.idBilling = @idBilling
  ORDER BY c.noResep, ba.namaBarang
END