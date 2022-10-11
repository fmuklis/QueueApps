CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanRekapTes]
	
	  @idJenisPendaftaran nvarchar = null
	 ,@tglDaftarPasien1 nvarchar(10) = null
	 ,@tglDaftarPasien2 nvarchar(10) = null

AS
BEGIN
	  DECLARE @Where Nvarchar(MAX) = ''
			  ,@Query Nvarchar(MAX);
		IF @idJenisPendaftaran Is Not Null And @tglDaftarPasien1 Is Null And @tglDaftarPasien2 Is Null
			Begin
				Set @Where = 'WHERE idJenisPendaftaran = '+@idJenisPendaftaran+''; 
			End
		ELSE IF @idJenisPendaftaran Is Not Null And @tglDaftarPasien1 Is Not Null And @tglDaftarPasien2 Is Null
			Begin
				Set @Where = 'WHERE idJenisPendaftaran = '+@idJenisPendaftaran+' And tglDaftarPasien1 = '+Convert(nvarchar(10),@tglDaftarPasien1)+''; 
			End
		ELSE IF @idJenisPendaftaran Is Not Null And @tglDaftarPasien1 Is Not Null And @tglDaftarPasien2 Is Not Null
			Begin
				Set @Where = 'WHERE idJenisPendaftaran = '+@idJenisPendaftaran+' And tglDaftarPasien1 Between '+@tglDaftarPasien1+' And '+@tglDaftarPasien2+''; 
			End
		ELSE IF  @tglDaftarPasien1 Is Not Null And @tglDaftarPasien2 Is Not Null And @idJenisPendaftaran Is Null
			Begin
				Set @Where = 'WHERE tglDaftarPasien Between '+@tglDaftarPasien1+' And '+@tglDaftarPasien2+''; 
			End	
		ELSE IF  @tglDaftarPasien1 Is Not Null And @tglDaftarPasien2 Is Null And @idJenisPendaftaran Is Null
			Begin
				Set @Where = 'WHERE tglDaftarPasien = '+@tglDaftarPasien1+''; 
			End	
		ELSE IF  @tglDaftarPasien2 Is Not Null And @tglDaftarPasien1 Is Null And @idJenisPendaftaran Is Null
			Begin
				Set @Where = 'WHERE tglDaftarPasien = '+@tglDaftarPasien2+''; 
			End													

	SET NOCOUNT ON;
 
SET @Query = 'SELECT Count(idPasien) pengunjungLama
			  FROM [dbo].[transaksiPendaftaranPasien]
		  '+@Where+'
			 GROUP BY idPasien Having COUNT(idPasien)>1;

			SELECT Count(idPasien) pengunjungBaru
			  FROM [dbo].[transaksiPendaftaranPasien]
		  '+@Where+'
			 GROUP BY idPasien Having COUNT(idPasien) = 1;

			SELECT namaMasterPelayanan,Count(a.idPasien) Jumlah
			  FROM [dbo].[transaksiPendaftaranPasien] a Inner Join masterRuanganPelayanan b On a.idRuangan = b.idRuangan
				   Inner Join masterPelayanan c On b.idMasterPelayanan = c.idMasterPelayanan
		  '+@Where+'
			 GROUP BY namaMasterPelayanan,a.idPasien;'
--select @Query;
Execute (@Query);
END