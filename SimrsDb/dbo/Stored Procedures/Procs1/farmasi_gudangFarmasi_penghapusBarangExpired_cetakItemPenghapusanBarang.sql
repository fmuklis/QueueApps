-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_cetakItemPenghapusanBarang]
	-- Add the parameters for the stored procedure here
	@idPenghapusanStok bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.namaBarang, b.tglExpired, b.kodeBatch, a.stokAwal AS stokAwal, b.stok AS stokAkhir
	  FROM dbo.farmasiPenghapusanStokDetail a
		   LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
		   OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) c
	 WHERE a.idPenghapusanStok = @idPenghapusanStok
END