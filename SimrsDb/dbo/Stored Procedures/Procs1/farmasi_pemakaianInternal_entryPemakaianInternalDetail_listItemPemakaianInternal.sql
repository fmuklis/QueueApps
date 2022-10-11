-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternalDetail_listItemPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@idPemakaianInternal bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idPenjualanDetail, c.namaBarang, a.kodeBatch, a.tglExpired, b.jumlah, c.satuanBarang
	  FROM dbo.farmasiMasterObatDetail a
		   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idObatDetail = b.idObatDetail AND b.idPemakaianInternal = @idPemakaianInternal
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) c
  ORDER BY c.namaBarang
END