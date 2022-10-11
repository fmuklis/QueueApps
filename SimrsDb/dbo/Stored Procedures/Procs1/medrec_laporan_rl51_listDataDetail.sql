CREATE PROCEDURE [dbo].[medrec_laporan_rl51_listDataDetail]
	-- Add the parameters for the stored procedure here	
	@tahun int,
	@bulan int

AS
BEGIN

	SET NOCOUNT ON;

    SELECT b.namaRuangan, Count(a.idPendaftaranPasien) Jumlah
	  FROM dbo.transaksiPendaftaranPasien a 
	 	   Inner Join dbo.masterRuangan b On a.idRuangan = b .idRuangan
	 WHERE a.idJenisPendaftaran = 2/*PendaftaranRajal*/ And a.idJenisPerawatan = 2/*PerawatanRajal*/ 
		   And Year(a.tglDaftarPasien) = @tahun And Month(a.tglDaftarPasien) = @bulan
  GROUP BY b.namaRuangan
  ORDER BY b.namaRuangan;
END