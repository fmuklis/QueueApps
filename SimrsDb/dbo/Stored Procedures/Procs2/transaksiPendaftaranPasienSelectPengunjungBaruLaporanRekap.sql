CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectPengunjungBaruLaporanRekap]
	
	  @idJenisPerawatan int
	 ,@Bulan int
	 ,@Tahun int

AS
BEGIN

	SET NOCOUNT ON;
 
Select 'Pengunjung Baru' as pasienBaru,ISNULL(Count(idPasien),0) as Jumlah From ( SELECT idPasien,tglDaftarPasien,idJenisPerawatan
												  FROM [dbo].[transaksiPendaftaranPasien]
											  GROUP BY idPasien,tglDaftarPasien,idJenisPerawatan Having COUNT(idPasien) = 1) x
WHERE x.idJenisPerawatan = @idJenisPerawatan And Year(x.tglDaftarPasien) = @Tahun And Month(x.tglDaftarPasien) = @Bulan;

END