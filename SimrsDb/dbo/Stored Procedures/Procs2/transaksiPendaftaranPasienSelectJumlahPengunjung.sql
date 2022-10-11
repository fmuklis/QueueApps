-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Jumlah Pendaftar (Lama/Baru)
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectJumlahPengunjung]
	-- Add the parameters for the stored procedure here
	 @idJenisPerawatan int = 2 --Default Rawat Jalan
	,@idJenisRuangan int = 3 --Default Poli Rawat Jalan
	,@Bulan int
	,@Tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @idPasienLama table (idPasienLama int);
		Insert Into @idPasienLama 
			 Select idPasien  From transaksiPendaftaranPasien 
			  Where year(tglDaftarPasien) < = @Tahun And month(tglDaftarPasien) < = @Bulan
		   Group By idPasien Having count(idPendaftaranPasien) > 1 ;

	CREATE TABLE #Temp ( nama nvarchar(225), jumlah int);
		INSERT INTO #Temp
			SELECT 'Pengunjung Baru' ,count(idPendaftaranPasien) as jumlah 
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan  
			 Where year(tglDaftarPasien) = @Tahun And month(tglDaftarPasien) = @Bulan And idPasien Not In (Select * From @idPasienLama) And idJenisPerawatan = @idJenisPerawatan And b.idJenisRuangan = @idJenisRuangan;
		INSERT INTO #Temp
			SELECT 'Pengunjung Lama' ,count(idPendaftaranPasien) as jumlah 
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
			 Where year(tglDaftarPasien) = @Tahun And month(tglDaftarPasien) = @Bulan And idPasien In (Select * From @idPasienLama) And idJenisPerawatan = @idJenisPerawatan And b.idJenisRuangan = @idJenisRuangan;
	SELECT * FROM #Temp;
	DROP TABLE #Temp;
END