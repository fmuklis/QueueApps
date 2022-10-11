CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_bayi_searchByIdPasien]
	@idPasien int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT a.idPekerjaanPasien, a.anakKePasien, a.idPasien, a.kodePasien, b.noRM, a.gelarDepanPasien, a.namaLengkapPasien, a.gelarBelakangPasien, a.tempatLahirPasien, a.tglLahirPasien, a.namaAyahPasien, a.namaIbuPasien
	      ,b.umur, b.namaPasien, b.noPenjamin, b.noDokumenIdentitasPasien, a.noHpPasien1, a.noHPPasien2, a.catatanKesehatan, a.alamatPasien, b.namaJenisKelamin
		  ,b.namaDesaKelurahan, b.namaKecamatan, a.anakKePasien, b.namaKabupaten, b.namaProvinsi
		  ,b.namaAgama, b.namaPekerjaan, a.idPendidikanPasien, b.namaPendidikan
		  ,b.idJenisKelamin AS idJenisKelaminPasien, b.idNegara, b.idProvinsi, b.idKabupaten, b.idKecamatan, b.idDesaKelurahan, b.anakKePasien, b.idAgamaPasien, b.idStatusPerkawinanPasien
		  ,a.idWargaNegaraPasien, b.namaWargaNegara, b.namaStatusPerkawinan, a.idDokumenIdentitasPasien, b.namaDokumenIdentitas
		  ,Case dbo.jumlahKata(a.namaLengkapPasien)
				When 1 
					 Then b.namaPasien
				Else a.namaLengkapPasien
			End As namaDiGelang
		  ,Case
				When a.namaAyahPasien = '-' Or a.idDesaKelurahanPasien Is Null
					 then 1
				else 0
			End as flagUpdate
	  FROM dbo.masterPasien a 
		   Outer Apply dbo.getinfo_datapasien(a.idPasien) b
	 WHERE a.idPasien = @idPasien;
END