CREATE PROCEDURE [dbo].[medrec_laporan_rl52_listDataDetail]
	-- Add the parameters for the stored procedure here	
	@tahun int,
	@bulan int

AS
BEGIN

	SET NOCOUNT ON;

    SELECT b.namaRuangan, COUNT(a.idPendaftaranPasien) Jumlah
	  FROM dbo.transaksiPendaftaranPasien a 
	 	   INNER JOIN dbo.masterRuangan b On a.idRuangan = b.idRuangan AND b.idJenisRuangan IN(1,3)/*RaJal,IGD*/
	 WHERE a.idJenisPerawatan = 2/*PerawatanRaJal*/ 
		   AND YEAR(a.tglDaftarPasien) = @Tahun AND MONTH(a.tglDaftarPasien) = @Bulan
  GROUP BY b.namaRuangan
  ORDER BY b.namaRuangan;
END