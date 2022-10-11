CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_dataPasien]
	 -- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT b.noRM, b.kodePasien, b.idPasien, b.namaPasien, b.Umur, b.namaPasien As namaLengkapPasien, b.tempatLahirPasien, b.tglLahirPasien, b.namaJenisKelamin, b.umur, b.namaPekerjaan, b.alamatPasien,namaDokumenIdentitas
		  ,b.noDokumenIdentitasPasien, b.namaAgama, b.namaPendidikan, b.namaDesaKelurahan, b.namaKecamatan, b.namaKabupaten, b.namaProvinsi, b.namaWargaNegara
		  ,b.namaStatusPerkawinan, b.noPenjamin,b. namaIbuPasien, b.namaAyahPasien,catatanKesehatan,noHp as noHpPasien1, '' as noHPPasien2
		  /*PENANGGUNG JAWAB*/
		  ,da.namaHubunganKeluarga, a.namaPenanggungJawabPasien, a.alamatPenanggungJawabPasien, a.noHpPenanggungJawab, a.idHubunganKeluargaPenanggungJawab
		  /*PENDAFTARAN*/
		  ,a.idPendaftaranPasien, g.diagnosaAwal, i.namaPelayananIGD, a.idJenisPendaftaran, a.idRuangan, a.tglDaftarPasien, a.idAsalPasien
		  ,aa.namaAsalPasien, a.namaTempatAsalPasien, ab.namaRuangan, a.idUser, d.namaLengkap, a.tglEntry, ac.namaStatusPendaftaran, ad.namaJenisPendaftaran, a.idDokter as idOperator, a.noReg
		  ,a.flagBerkasTidakLengkap, a.idDokter As DPJP, a.keluhan, g.diagnosaAwal, a.keteranganPendaftaran, c.NamaOperator, ea.idJenisPenjaminPembayaranPasien, ea.namaJenisPenjaminPembayaranPasien
		  ,a.idKelasPenjaminPembayaran, a.rujukan
		  ,ea.flagKenakelas, a.noSEPRawatJalan AS noSEP,ea.idJenisPenjaminInduk, ab.namaRuangan, hb.namaRuanganRawatInap, hc.namaKelas As kelasRuangan, a.tglDaftarPasien, a.tglKeluarPasien
		  ,Case
				When a.idJenisPerawatan = 1/*Rawat Inap*/
					 Then ja.namaRuangan
				Else ab.namaRuangan
		   End As namaPoli
		  ,Case
				When a.idJenisPerawatan = 1/*Rawat Inap*/
					 Then ka.NamaOperator
				Else c.NamaOperator
		   End As operatorPoli
	FROM [dbo].[transaksiPendaftaranPasien] a
		 Inner Join [dbo].[masterAsalPasien] aa on a.[idAsalPasien] = aa.[idAsalPasien]
		 Inner Join [dbo].[masterRuangan] ab on a.[idRuangan] = ab.[idRuangan]
		 Inner Join [dbo].[masterStatusPendaftaran] ac on a.[idStatusPendaftaran] = ac.[idStatusPendaftaran]
		 Inner Join [dbo].[masterJenisPendaftaran] ad on a.[idJenisPendaftaran] = ad.[idJenisPendaftaran]
		 Cross Apply dbo.getinfo_datapasien(a.idPasien) b
				left Join [dbo].[masterHubunganKeluarga] da on a.idHubunganKeluargaPenanggungJawab = da.[idHubunganKeluarga]					
				Inner Join masterJenisPenjaminPembayaranPasien ea On a.idJenisPenjaminPembayaranPasien = ea.idJenisPenjaminPembayaranPasien
				Inner Join masterJenisPenjaminPembayaranPasienInduk eaa on ea.idJenisPenjaminInduk = eaa.idJenisPenjaminInduk
		 Left Join dbo.masterOperator c On a.idDokter = c.idOperator
		 Left Join dbo.masterUser d On a.idUser = d.idUser
		 Left Join dbo.transaksiDiagnosaPasien g On a.idPendaftaranPasien = g.idPendaftaranPasien
		 Left Join dbo.transaksiPendaftaranPasienDetail h On a.idPendaftaranPasien = h.idPendaftaranPasien And h.aktif = 1
				Left Join dbo.masterRuanganTempatTidur ha On h.idTempatTidur = ha.idTempatTidur
				Left Join dbo.masterRuanganRawatInap hb On ha.idRuanganRawatInap = hb.idRuanganRawatInap
				Left Join dbo.masterKelas hc On hb.idKelas = hc.idKelas
				Left Join dbo.masterRuangan hd On hb.idRuangan = hd.idRuangan
		 Left Join dbo.masterPelayananIGD i On a.idPelayananIGD = i.idPelayananIGD
		 Left Join dbo.transaksiOrderRawatInap j On a.idPendaftaranPasien = j.idPendaftaranPasien
				Left Join dbo.masterRuangan ja On j.idRuanganAsal = ja.idRuangan
		 Left Join dbo.transaksiOrderRawatInap k On a.idPendaftaranPasien = k.idPendaftaranPasien
				Left Join dbo.masterOperator ka On k.idDokter = ka.idOperator
   WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END