-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarangDetail_listItemOrder]
	-- Add the parameters for the stored procedure here
	@idPembelianHeader bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idOrderDetail, bb.namaBarang, bb.satuanBarang, b.jumlah AS jumlahOrder
		  ,b.jumlah - SUM(ISNULL(ba.jumlahBeli, 0)) AS sisaPenerimaan, b.harga AS hargaBeli
	  FROM dbo.farmasiPembelian a
		   INNER JOIN dbo.farmasiOrderDetail b ON a.idOrder = b.idOrder
				LEFT JOIN dbo.farmasiPembelianDetail ba ON b.idOrderDetail = ba.idOrderDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) bb
	 WHERE a.idPembelianHeader = @idPembelianHeader
  GROUP BY b.idOrderDetail, bb.namaBarang, bb.satuanBarang, b.jumlah, b.harga
    HAVING b.jumlah > SUM(ISNULL(ba.jumlahBeli, 0))
  ORDER BY bb.namaBarang
END