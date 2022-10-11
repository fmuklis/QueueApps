-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Data Distributor Farmasi
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_laporan_pembelian_listDistributor
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT ba.idDistrobutor, ba.namaDistroButor
	  FROM dbo.farmasiPembelian a
		   INNER JOIN dbo.farmasiOrder b ON a.idOrder = b.idOrder
				INNER JOIN dbo.farmasiMasterDistrobutor ba ON b.idDistriButor = ba.idDistrobutor
	 WHERE CAST(a.tglPembelian AS date) BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY ba.namaDistroButor
END