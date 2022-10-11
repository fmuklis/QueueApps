-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_fakturPengadaan_listData]
	@PeriodeAwal date,
	@PeriodeAkhir date,
	@idDistributor int,
	@idPabrik int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT gb.namaBarang, a.tglPembelian, ca.namaDistroButor, ga.namaPabrik, gb.satuanBarang, b.hargaBeli
		  ,b.discountPersen, b.discountUang, b.jumlahBeli, a.ppn, (((b.hargaBeli * b.jumlahBeli) - b.discountUang) * b.discountPersen / 100) + b.discountUang As jumlahDiscount
		  ,((b.hargaBeli * b.jumlahBeli) - ((((b.hargaBeli * b.jumlahBeli) - b.discountUang) * b.discountPersen / 100) + b.discountUang)) * a.ppn / 100 As jumlahPPN
		  ,b.hargaBeli * b.jumlahBeli As total
	  FROM dbo.farmasiPembelian a
		   INNER JOIN dbo.farmasiPembelianDetail b ON a.idPembelianHeader = b.idPembelianHeader
		   INNER JOIN dbo.farmasiOrder c ON a.idOrder = c.idOrder
				LEFT JOIN dbo.farmasiMasterDistrobutor ca ON c.idDistriButor = ca.idDistrobutor
		   INNER JOIN dbo.farmasiOrderDetail g On b.idOrderDetail = g.idOrderDetail
				LEFT JOIN dbo.farmasiMasterPabrik ga ON g.idPabrik = ga.idPabrik
				OUTER APPLY dbo.getInfo_barangFarmasi(g.idObatDosis) gb
	 WHERE a.tglPembelian BETWEEN @PeriodeAwal AND @PeriodeAkhir AND c.idDistriButor = @idDistributor AND g.idPabrik = @idPabrik
  ORDER BY a.tglPembelian
END