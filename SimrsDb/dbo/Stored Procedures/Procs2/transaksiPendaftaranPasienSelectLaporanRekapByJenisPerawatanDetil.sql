CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanRekapByJenisPerawatanDetil]	
	  @idJenisPerawatan nvarchar(225)
	 ,@tglDaftarPasien nvarchar(10) = null
	 ,@tglDaftarPasien2 nvarchar(10) = null
	 ,@bulan nvarchar(2) = null
	 ,@tahun nvarchar(5) = null

AS
BEGIN
	Declare @Where nvarchar(MAX) = ''
			,@Query nvarchar(MAX);
		If @tahun Is Not Null And @bulan Is Null And @tglDaftarPasien Is Null And @tglDaftarPasien2 Is Null 
			Begin
				Set @Where = 'WHERE Year(a.tglDaftarPasien) = '+@tahun+' And b.idJenisPerawatan = '+@idJenisPerawatan
			End
		If @tahun Is Not Null And @bulan Is Not Null And @tglDaftarPasien Is Null And @tglDaftarPasien2 Is Null 
			Begin
				Set @Where = 'WHERE Year(a.tglDaftarPasien) = '+@tahun+'And Month(a.tglDaftarPasien) = '+@bulan+' And b.idJenisPerawatan = '+@idJenisPerawatan
			End
		If @tahun Is Null And @bulan Is Null And @tglDaftarPasien Is Not Null And @tglDaftarPasien2 Is Not Null 
			Begin
				Set @Where = 'WHERE b.idJenisPerawatan = '+@idJenisPerawatan+' And a.tglDaftarPasien Between '''+@tglDaftarPasien+''' And '''+@tglDaftarPasien2+''''  
			End

	SET NOCOUNT ON;

SET @Query = 'SELECT namaRuangan,[LAKI-LAKI],[PEREMPUAN]
			FROM (SELECT b.idJenisPerawatan,d.namaRuangan,ca.namaJenisKelamin,ISNULL(Count(a.idPasien),0) as Jumlah
					FROM [dbo].[transaksiPendaftaranPasien] a
						 Inner Join masterJenisPerawatan b On a.idJenisPerawatan = b.idJenisPerawatan
						 Inner join masterPasien c On a.idPasien = c.idPasien
							 Inner Join masterJenisKelamin ca On c.idJenisKelaminPasien = ca.idJenisKelamin
						 Inner Join masterRuangan d On a.idRuangan = d.idRuangan
				   '+@Where+'
				GROUP BY b.idJenisPerawatan,d.namaRuangan,ca.namaJenisKelamin
				) X
		PIVOT ( SUM(Jumlah)
				FOR namaJenisKelamin in ([LAKI-LAKI],[PEREMPUAN])) P;'

EXECUTE(@Query);
END