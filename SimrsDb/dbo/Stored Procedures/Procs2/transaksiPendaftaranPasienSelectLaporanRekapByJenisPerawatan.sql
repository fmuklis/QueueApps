CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanRekapByJenisPerawatan]	
	  @tglDaftarPasien nvarchar(10) = null
	 ,@tglDaftarPasien2 nvarchar(10) = null
	 ,@bulan nvarchar(2) = null
	 ,@tahun nvarchar(5) = null

AS
BEGIN
	Declare @Where nvarchar(MAX) = ''
			,@Query nvarchar(MAX);
		If @tahun Is Not Null And @bulan Is Null And @tglDaftarPasien Is Null And @tglDaftarPasien2 Is Null 
			Begin
				Set @Where = 'WHERE Year(a.tglDaftarPasien) = '+@tahun
			End
		If @tahun Is Not Null And @bulan Is Not Null And @tglDaftarPasien Is Null And @tglDaftarPasien2 Is Null 
			Begin
				Set @Where = 'WHERE Year(a.tglDaftarPasien) = '+@tahun+'And Month(a.tglDaftarPasien) = '+@bulan+''
			End
		If @tahun Is Null And @bulan Is Null And @tglDaftarPasien Is Not Null And @tglDaftarPasien2 Is Not Null 
			Begin
				Set @Where = 'WHERE a.tglDaftarPasien Between '''+@tglDaftarPasien+''' And '''+@tglDaftarPasien2+''''  
			End

	SET NOCOUNT ON;

SET @Query = 'SELECT namaJenisPerawatan,[LAKI-LAKI],[PEREMPUAN]
			FROM (SELECT b.namaJenisPerawatan,ca.namaJenisKelamin,ISNULL(Count(a.idPasien),0) as Jumlah
					FROM [dbo].[transaksiPendaftaranPasien] a
						 Inner Join masterJenisPerawatan b On a.idJenisPerawatan = b.idJenisPerawatan
						 Inner join masterPasien c On a.idPasien = c.idPasien
							 Inner Join masterJenisKelamin ca On c.idJenisKelaminPasien = ca.idJenisKelamin
				   '+@Where+'
				GROUP BY b.namaJenisPerawatan,ca.namaJenisKelamin
				) X
		PIVOT ( SUM(Jumlah)
				FOR namaJenisKelamin in ([LAKI-LAKI],[PEREMPUAN])) P;'

EXECUTE(@Query);
Select @Query;
END