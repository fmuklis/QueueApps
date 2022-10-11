-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpiredDetail_listObat]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObatDetail, b.namaBarang AS namaObat, a.stok
	  FROM dbo.farmasiMasterObatDetail a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   LEFT JOIN dbo.farmasiPenghapusanStokDetail c ON a.idObatDetail = c.idObatDetail
	 WHERE a.tglExpired < GETDATE() AND a.stok > 0 AND a.idJenisStok = 1 /* Gudang Farmasi */
		   AND c.idPenghapusanStokDetail IS NULL
  ORDER BY b.namaBarang
END