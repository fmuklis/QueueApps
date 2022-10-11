CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectAll]
	
	 @namaLengkapPasien nvarchar(100) = null
	,@tglDaftarPasien1 date = null
	,@tglDaftarPasien2 date = null

AS
BEGIN

	SET NOCOUNT ON;

	if @namaLengkapPasien is not null and (@tglDaftarPasien1 = '1970-01-01' or @tglDaftarPasien1 is null) and (@tglDaftarPasien2 = '1970-01-01' or @tglDaftarPasien2 is null)
		begin
			if exists ( select 1 from [transaksiPendaftaranPasien] a inner join [masterPasien] b on b.[idPasien] = a.[idPasien] where namaLengkapPasien like '%'+@namaLengkapPasien+'%' or kodePasien like '%' + @namaLengkapPasien + '%')
				begin 
				SELECT 'Data Ditemukan' as respon, 1 as responCode, [idPendaftaranPasien], [kodePasien], [namaLengkapPasien], [namaJenisKelamin], [tempatLahirPasien], [tglLahirPasien], [alamatPasien], [noHpPasien1], [noHPPasien2], [catatanKesehatan]   
							,[tglDaftarPasien], [namaJenisPendaftaran], [namaRuangan], [namaStatusPendaftaran]
							FROM [dbo].[transaksiPendaftaranPasien] a
							inner join [dbo].[masterPasien] b on b.[idPasien] = a.[idPasien]
							inner join [dbo].[masterJenisPendaftaran] c on a.[idJenisPendaftaran] = c.[idJenisPendaftaran]
							inner join [dbo].[masterAsalPasien] e on a.[idAsalPasien] = e.[idAsalPasien]
							inner join [dbo].[masterRuangan] f on a.[idRuangan] = f.[idRuangan]
							inner join [dbo].[masterStatusPendaftaran] g on a.[idStatusPendaftaran] = g.[idStatusPendaftaran] 
							inner join [dbo].[masterJenisKelamin] h on b.[idJenisKelaminPasien] = h.[idJenisKelamin]
							where namaLengkapPasien like '%'+@namaLengkapPasien+'%'  or b.kodePasien like '%' + @namaLengkapPasien + '%'
							order by [namaLengkapPasien] asc
				end
			else
				begin
				SELECT 'Data Tidak Ditemukan' as respon, 0 as responCode
				end
		end
	else if @namaLengkapPasien is null and  (@tglDaftarPasien1 ! = '1970-01-01' or @tglDaftarPasien1 is not null) and (@tglDaftarPasien2 ! = '1970-01-01' or @tglDaftarPasien2 is not null)
		begin
			if exists ( select 1 from [transaksiPendaftaranPasien] a inner join [masterPasien] b on b.[idPasien] = a.[idPasien] where [tglDaftarPasien] between @tglDaftarPasien1 and @tglDaftarPasien2 )
				begin
					SELECT 'Data Ditemukan' as respon, 1 as responCode, [idPendaftaranPasien], [kodePasien], [namaLengkapPasien], [namaJenisKelamin],[tempatLahirPasien], [tglLahirPasien], [alamatPasien], [noHpPasien1], [noHPPasien2], [catatanKesehatan]   
								,[tglDaftarPasien], [namaJenisPendaftaran], [namaRuangan], [namaStatusPendaftaran]
								FROM [dbo].[transaksiPendaftaranPasien] a
								inner join [dbo].[masterPasien] b on b.[idPasien] = a.[idPasien]
								inner join [dbo].[masterJenisPendaftaran] c on a.[idJenisPendaftaran] = c.[idJenisPendaftaran]

								inner join [dbo].[masterAsalPasien] e on a.[idAsalPasien] = e.[idAsalPasien]
								inner join [dbo].[masterRuangan] f on a.[idRuangan] = f.[idRuangan]
								inner join [dbo].[masterStatusPendaftaran] g on a.[idStatusPendaftaran] = g.[idStatusPendaftaran] 
								inner join [dbo].[masterJenisKelamin] h on b.[idJenisKelaminPasien] = h.[idJenisKelamin]
								where [tglDaftarPasien] between @tglDaftarPasien1 and @tglDaftarPasien2
								order by [namaLengkapPasien] asc
				end
			else
				begin
				SELECT 'Data Tidak Ditemukan' as respon, 0 as responCode
				end
		end
	else if @namaLengkapPasien is not null and  (@tglDaftarPasien1 ! = '1970-01-01' or @tglDaftarPasien1 is not null) and (@tglDaftarPasien2 ! = '1970-01-01' or @tglDaftarPasien2 is null)
		begin
			if exists ( select 1 from [transaksiPendaftaranPasien] a inner join [masterPasien] b on b.[idPasien] = a.[idPasien] where namaLengkapPasien like '%'+@namaLengkapPasien+'%' and ([tglDaftarPasien] between @tglDaftarPasien1 and @tglDaftarPasien2) )
				begin
					SELECT 'Data Ditemukan' as respon, 1 as responCode, [idPendaftaranPasien], [kodePasien], [namaLengkapPasien], [namaJenisKelamin],[tempatLahirPasien], [tglLahirPasien], [alamatPasien], [noHpPasien1], [noHPPasien2], [catatanKesehatan]   
							,[tglDaftarPasien], [namaJenisPendaftaran], [namaRuangan], [namaStatusPendaftaran]
					FROM [dbo].[transaksiPendaftaranPasien] a
					inner join [dbo].[masterPasien] b on b.[idPasien] = a.[idPasien]
					inner join [dbo].[masterJenisPendaftaran] c on a.[idJenisPendaftaran] = c.[idJenisPendaftaran]
				
					inner join [dbo].[masterAsalPasien] e on a.[idAsalPasien] = e.[idAsalPasien]
					inner join [dbo].[masterRuangan] f on a.[idRuangan] = f.[idRuangan]
					inner join [dbo].[masterStatusPendaftaran] g on a.[idStatusPendaftaran] = g.[idStatusPendaftaran] 
					inner join [dbo].[masterJenisKelamin] h on b.[idJenisKelaminPasien] = h.[idJenisKelamin]
					where (namaLengkapPasien like '%'+@namaLengkapPasien+'%' or b.kodePasien like '%' + @namaLengkapPasien + '%') and ([tglDaftarPasien] between @tglDaftarPasien1 and @tglDaftarPasien2)
					order by [namaLengkapPasien] asc
				end
			else
				begin
					SELECT 'Data Tidak Ditemukan' as respon, 0 as responCode
				end
		end

END