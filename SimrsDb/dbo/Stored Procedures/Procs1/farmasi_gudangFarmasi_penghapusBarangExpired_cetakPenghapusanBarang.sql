-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_cetakPenghapusanBarang]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalPenghapusan, a.kodePenghapusan, b.namaPetugasFarmasi AS pemohon, cb.namaBarang
		  ,ca.kodeBatch, ca.tglExpired, c.stokAwal, ca.stok AS stokAkhir
	  FROM dbo.farmasiPenghapusanStok a
		   LEFT JOIN dbo.farmasiMasterPetugas b ON a.idPetugas = b.idPetugasFarmasi
		   INNER JOIN dbo.farmasiPenghapusanStokDetail c ON a.idPenghapusanStok = c.idPenghapusanStok
				LEFT JOIN dbo.farmasiMasterObatDetail ca ON c.idObatDetail = ca.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(ca.idObatDosis) cb
	 WHERE a.tanggalPenghapusan BETWEEN @periodeAwal AND @periodeAkhir AND a.idStatusPenghapusan = 5/*Valid*/
END