CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_selectByIdReg]
	
	 @idPendaftaranPasien bigint

AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
    -- PASIEN --  
       a.idPasien, b.noRM, b.namaPasien As namaLengkapPasien, b.tglLahirPasien, b.alamatPasien, b.namaDesaKelurahan, b.namaJenisKelamin, b.Umur, b.namaKecamatan, b.namaKabupaten, b.namaProvinsi
	   , b.noDokumenIdentitasPasien, b.namaPekerjaan, b.namaAgama, b.namaWargaNegara, a.tglDaftarPasien, i.namaPelayananIGD, l.diagnosa, b.noPenjamin, b.namaPendidikan
	  ,b.namaStatusPerkawinan, a.rujukan,a.flagBerkasTidakLengkap, a.keteranganPendaftaran AS keterangan, a.noSEPRawatJalan as noSEP,ea.idJenisPenjaminInduk, a.idAsalPasien, b.kodePasien
	  , ea.namaJenisPenjaminPembayaranPasien/*
    -- PENANGGUNG JAWAB -- 
      ,da.namaHubunganKeluarga, a.namaPenanggungJawabPasien, a.alamatPenanggungJawabPasien, a.noHpPenanggungJawab, a.idHubunganKeluargaPenanggungJawab
    -- PENDAFTARAN --
	  ,a.idPendaftaranPasien, a.idJenisPendaftaran, a.idRuangan
	  ,aa.namaAsalPasien, a.namaTempatAsalPasien, ab.namaRuangan, a.idUser, d.namaLengkap, a.tglEntry, ac.namaStatusPendaftaran, ad.namaJenisPendaftaran, a.idDokter as idOperator, a.noReg
    -- PENDAFTARAN --
	  , a.idDokter As DPJP, a.anamnesa, c.NamaOperator
	  ,ea.idJenisPenjaminPembayaranPasien, a.idKelasPenjaminPembayaran as idKelasPenjamin
	  ,ea.flagKenakelas , ab.namaRuangan, hb.namaRuanganRawatInap, hc.namaKelas As kelasRuangan, a.tglDaftarPasien, a.tglKeluarPasien
	  ,Case
			When a.idJenisPerawatan = 1/*Rawat Inap*/
				 Then ja.namaRuangan
			Else ab.namaRuangan
	   End As namaPoli
	  ,Case
			When a.idJenisPerawatan = 1/*Rawat Inap*/
				 Then ka.NamaOperator
			Else c.NamaOperator
	   End As operatorPoli*/
	FROM dbo.transaksiPendaftaranPasien a
		 left Join dbo.masterAsalPasien aa on a.idAsalPasien = aa.idAsalPasien
		 left Join dbo.masterRuangan ab on a.idRuangan = ab.idRuangan
		 left Join [dbo].[masterStatusPendaftaran] ac on a.[idStatusPendaftaran] = ac.[idStatusPendaftaran]
		 left Join [dbo].[masterJenisPendaftaran] ad on a.[idJenisPendaftaran] = ad.[idJenisPendaftaran]
		 Outer Apply dbo.getinfo_datapasien(a.idPasien) b
				left Join [dbo].[masterHubunganKeluarga] da on a.idHubunganKeluargaPenanggungJawab = da.[idHubunganKeluarga]					
				left Join masterJenisPenjaminPembayaranPasien ea On a.idJenisPenjaminPembayaranPasien=ea.idJenisPenjaminPembayaranPasien
				left Join masterJenisPenjaminPembayaranPasienInduk eaa on ea.idJenisPenjaminInduk=eaa.idJenisPenjaminInduk
		 Left Join dbo.masterOperator c On a.idDokter = c.idOperator
		 Left Join dbo.masterUser d On a.idUser = d.idUser
		 Left Join dbo.transaksiPendaftaranPasienDetail h On a.idPendaftaranPasien = h.idPendaftaranPasien And h.aktif = 1
				Left Join dbo.masterRuanganTempatTidur ha On h.idTempatTidur = ha.idTempatTidur
				Left Join dbo.masterRuanganRawatInap hb On ha.idRuanganRawatInap = hb.idRuanganRawatInap
				Left join dbo.masterKelas hc On hb.idKelas = hc.idKelas
				Left Join dbo.masterRuangan hd On hb.idRuangan = hd.idRuangan
		 Left Join dbo.masterPelayananIGD i On a.idPelayananIGD = i.idPelayananIGD
		 Left Join dbo.transaksiOrderRawatInap j On a.idPendaftaranPasien = j.idPendaftaranPasien
				Left Join dbo.masterRuangan ja On j.idRuanganAsal = ja.idRuangan
		 Left Join dbo.transaksiOrderRawatInap k On a.idPendaftaranPasien = k.idPendaftaranPasien
				Left Join dbo.masterOperator ka On k.idDokter = ka.idOperator
		outer apply dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) l
   WHERE a.[idPendaftaranPasien] = @idPendaftaranPasien

END