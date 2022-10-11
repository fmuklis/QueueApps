CREATE PROCEDURE [dbo].[masterPasienInsertManual]
	
    @kodePasien nchar(6),
	@namaLengkapPasien nvarchar(100),
    @gelarDepanPasien nvarchar(50),
    @gelarBelakangPasien nvarchar(50),
    @idPekerjaanPasien int,
    @tempatLahirPasien nvarchar(50),
    @tglLahirPasien date,
    @idJenisKelaminPasien int,
    @alamatPasien nvarchar(250),
    @idDesaKelurahanPasien int,
    @namaAyahPasien nvarchar(50),
    @namaIbuPasien nvarchar(50),
    @anakKePasien int,
    @idDokumenIdentitasPasien int,
    @noDokumenIdentitasPasien nvarchar(50),
    @idPendidikanPasien int,
    @idAgamaPasien int,
    @idWargaNegaraPasien int,
    @noHpPasien1 nvarchar(50),
    @noHPPasien2 nvarchar(50),
    @idStatusPerkawinanPasien int,
	@catatanKesehatan nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		if  not exists (select 1 from [dbo].[masterPasien] where [namaLengkapPasien] = @namaLengkapPasien 
			and [tempatLahirPasien] = @tempatLahirPasien and[tglLahirPasien] = @tglLahirPasien)
		begin
			if not exists(select 1 from [dbo].[masterPasien] where kodePasien = @kodePasien)
			Begin
					INSERT INTO [dbo].[masterPasien]
				   ([kodePasien]
				   ,[namaLengkapPasien]
				   ,[gelarDepanPasien]
				   ,[gelarBelakangPasien]
				   ,[idPekerjaanPasien]
				   ,[tempatLahirPasien]
				   ,[tglLahirPasien]
				   ,[idJenisKelaminPasien]
				   ,[alamatPasien]
				   ,[idDesaKelurahanPasien]
				   ,[namaAyahPasien]
				   ,[namaIbuPasien]
				   ,[anakKePasien]
				   ,[idDokumenIdentitasPasien]
				   ,[noDokumenIdentitasPasien]
				   ,[idPendidikanPasien]
				   ,[idAgamaPasien]
				   ,[idWargaNegaraPasien]
				   ,[noHpPasien1]
				   ,[noHPPasien2]
				   ,[idStatusPerkawinanPasien]
				   ,[catatanKesehatan])
					VALUES
				   ( @kodePasien
					,@namaLengkapPasien
					,@gelarDepanPasien
					,@gelarBelakangPasien
					,@idPekerjaanPasien
					,@tempatLahirPasien
					,@tglLahirPasien
					,@idJenisKelaminPasien
					,@alamatPasien
					,@idDesaKelurahanPasien
					,@namaAyahPasien
					,@namaIbuPasien
					,@anakKePasien
					,@idDokumenIdentitasPasien
					,@noDokumenIdentitasPasien
					,@idPendidikanPasien
					,@idAgamaPasien
					,@idWargaNegaraPasien
					,@noHpPasien1
					,@noHPPasien2
					,@idStatusPerkawinanPasien
					,@catatanKesehatan);
			select 'Data Pasien Berhasil Disimpan' as respon, 1 as responCode,@kodePasien as kodePasien;
			end
			Else
			Begin
				select 'Maaf Kode Pasien'+@kodePasien+'Sudah Ada/Digunakan' as respon, 0 as responCode,'' as kodePasien;
			End
		end
		else
		begin
			select 'Maaf Data Pasien Sudah Ada' as respon, 0 as responCode;
		end
END