-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_selectForAdmisi]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.idPasien, b.noPenjamin
		   --DATA PASIEN
		  ,b.kodePasien, b.noRM, b.namaPasien, b.alamatPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur, b.namaAyahPasien
		  ,b.anakKePasien
		   --PENJAMIN PEMBAYARAN
		  ,c.idJenisPenjaminInduk, c.namaJenisPenjaminPembayaranPasien
		   --PENANGGUNG JAWAB
		  ,a.namaPenanggungJawabPasien, a.idHubunganKeluargaPenanggungJawab, i.namaHubunganKeluarga, a.alamatPenanggungJawabPasien
		  ,a.noHpPenanggungJawab
		   --data rawat Inap
		  ,d.tanggalMasuk As tglDaftarRawatInap, a.idRuangan, h.namaRuangan, da.idRuanganRawatInap, db.namaRuanganRawatInap, a.idDokter, d.idTempatTidur
		  ,da.noTempatTidur, g.namaKelas As kelasPenjaminPasien, f.NamaOperator, a.depositRawatInap, d.keterangan, dc.idKelas, dc.namaKelas As kelasKamar
		  ,a.idKelasPenjaminPembayaran, d.idStatusPendaftaranRawatInap
			,a.flagBerkasTidakLengkap,a.keteranganPendaftaran, a.noSEPRawatInap as noSEP, a.idStatusPendaftaran
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
		   Left Join dbo.transaksiPendaftaranPasienDetail d On a.idPendaftaranPasien = d.idPendaftaranPasien And d.aktif = 1
				Left Join dbo.masterRuanganTempatTidur da On d.idTempatTidur = da.idTempatTidur
				Left Join dbo.masterRuanganRawatInap db On da.idRuanganRawatInap = db.idRuanganRawatInap
				Left Join dbo.masterKelas dc On db.idKelas = dc.idKelas
		   Left Join dbo.masterOperator f On a.idDokter = f.idOperator
		   Left Join dbo.masterKelas g On a.idKelasPenjaminPembayaran = g.idKelas
		   Left Join dbo.masterRuangan h On a.idRuangan = h.idRuangan
		   LEFT JOIN dbo.masterHubunganKeluarga i ON a.idHubunganKeluargaPenanggungJawab = i.idHubunganKeluarga
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END