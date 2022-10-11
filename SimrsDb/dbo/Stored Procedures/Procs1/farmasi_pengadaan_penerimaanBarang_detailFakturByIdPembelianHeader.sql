-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_detailFakturByIdPembelianHeader]
	-- Add the parameters for the stored procedure here
	@idPembelianHeader int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPembelianHeader, b.idDistriButor, a.noFaktur, a.tglPembelian, a.tglJatuhTempoPembayaran
		  ,a.keterangan, a.idStatusPembelian, ba.namaDistroButor, a.ppn
	  FROM dbo.farmasiPembelian a
		   LEFT JOIN dbo.farmasiOrder b ON a.idOrder = b.idOrder
				LEFT JOIN dbo.farmasiMasterDistrobutor ba ON b.idDistriButor = ba.idDistrobutor
	 WHERE a.idPembelianHeader = @idPembelianHeader;
END