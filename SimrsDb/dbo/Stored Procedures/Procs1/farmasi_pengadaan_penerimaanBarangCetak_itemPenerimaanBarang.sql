-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarangCetak_itemPenerimaanBarang]
	-- Add the parameters for the stored procedure here
	@idPembelianHeader bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.namaBarang, a.kodeBatch, a.tglExpired, a.hargaBeli, a.discountUang, a.discountPersen, a.jumlahBeli, ba.satuanBarang
	  FROM dbo.farmasiPembelianDetail a
		   INNER JOIN dbo.farmasiOrderDetail b ON a.idOrderDetail = b.idOrderDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
	 WHERE a.idPembelianHeader = @idPembelianHeader
  ORDER BY ba.namaBarang
END