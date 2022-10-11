CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectPengunjungLamaLaporanRekap]
	
	  @idJenisPendaftaran int
	 ,@Bulan int
	 ,@Tahun int

AS
BEGIN

	SET NOCOUNT ON;
 
Select 'Pengunjung Lama' as pasienLama,ISNULL(Count(idPasien),0) as Jumlah From ( SELECT idPasien,tglDaftarPasien,idJenisPerawatan
												  FROM [dbo].[transaksiPendaftaranPasien]
											  GROUP BY idPasien,tglDaftarPasien,idJenisPerawatan Having COUNT(idPasien)>1) x
WHERE x.idJenisPerawatan = @idJenisPendaftaran And Year(x.tglDaftarPasien) = @Tahun And Month(x.tglDaftarPasien) = @Bulan;

END