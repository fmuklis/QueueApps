CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanRekap]
	
	  @idJenisPerawatan int = 2 --Default Rawat Jalan
	 ,@idJenisRuangan int = 3 --Default Poli Rawat Jalan
	 ,@Bulan int
	 ,@Tahun int

AS
BEGIN

	SET NOCOUNT ON;

    SELECT b.namaRuangan ,Count(a.idPendaftaranPasien) Jumlah
	  FROM [dbo].[transaksiPendaftaranPasien] a 
	 	   Inner Join dbo.masterRuangan b On a.idRuangan = b .idRuangan
		   Inner Join dbo.masterRuanganJenis c On b.idJenisRuangan = c.idJenisRuangan
	 WHERE a.idJenisPerawatan = @idJenisPerawatan And Year(a.tglDaftarPasien) = @Tahun And Month(a.tglDaftarPasien) = @Bulan And c.idJenisRuangan = @idJenisRuangan
	 GROUP BY b.namaRuangan ;
END