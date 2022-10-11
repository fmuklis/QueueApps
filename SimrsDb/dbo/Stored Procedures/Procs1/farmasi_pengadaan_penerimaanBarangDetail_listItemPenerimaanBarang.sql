-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarangDetail_listItemPenerimaanBarang]
	-- Add the parameters for the stored procedure here
	@idPembelianHeader bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPembelianDetail, ba.namaBarang, ba.satuanBarang, a.kodeBatch, a.tglExpired, a.jumlahBeli, a.hargaBeli
		  ,a.discountPersen, a.discountUang, c.ppn
	  FROM dbo.farmasiPembelianDetail a
		   INNER JOIN dbo.farmasiOrderDetail b On a.idOrderDetail = b.idOrderDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
		   LEFT JOIN dbo.farmasiPembelian c ON a.idPembelianHeader = c.idPembelianHeader
	 WHERE a.idPembelianHeader = @idPembelianHeader
  ORDER BY ba.namaBarang
END