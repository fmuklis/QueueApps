CREATE PROCEDURE [dbo].farmasi_laporan_pengadaanFarmasi_listData
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tglOrder, a.noOrder, c.namaDistroButor, ba.namaPabrik, bb.namaBarang, bb.satuanBarang, b.jumlah
		  ,d.orderSumberAnggaran
	  FROM dbo.farmasiOrder a
		   INNER JOIN dbo.farmasiOrderDetail b ON a.idOrder = b.idOrder
				LEFT JOIN dbo.farmasiMasterPabrik ba ON b.idPabrik = ba.idPabrik
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) bb
		   LEFT JOIN dbo.farmasiMasterDistrobutor c ON a.idDistriButor = c.idDistrobutor
		   LEFT JOIN dbo.farmasiOrderSumberAnggaran d ON a.idOrderSumberAnggaran = d.idOrderSumberAnggaran
	 WHERE a.idStatusOrder >= 2/*Order Valid*/ AND a.tglOrder BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY a.tglOrder
END