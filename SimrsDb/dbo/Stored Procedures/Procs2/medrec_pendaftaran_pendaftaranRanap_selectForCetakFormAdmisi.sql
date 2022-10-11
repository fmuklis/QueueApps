-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_selectForCetakFormAdmisi]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.noReg, a.tglDaftarPasien, b.noRM, b.namaPasien, b.alamatPasien, b.namaDokumenIdentitas, b.noDokumenIdentitasPasien, b.namaDesaKelurahan
		  ,b.namaKecamatan, b.namaKabupaten, b.namaProvinsi, b.namaJenisKelamin, b.tglLahirPasien, b.umur, c.namaJenisPenjaminPembayaranPasien
		  ,b.namaPekerjaan, b.namaAgama, b.namaStatusPerkawinan, b.namaWargaNegara, b.namaPendidikan
		  ,a.namaPenanggungJawabPasien, e.namaHubunganKeluarga, a.alamatPenanggungJawabPasien, a.noHpPenanggungJawab, d.tanggalMasuk As tglDaftarRawatInap
		  ,db.namaRuanganRawatInap, da.noTempatTidur, g.namaKelas As kelasPenjaminPasien, f.NamaOperator
		  ,h.namaAsalPasien, ia.namaLengkap, dc.Alias
	  FROM dbo.transaksiPendaftaranPasien a
		   Cross Apply dbo.getinfo_datapasien(a.idPasien) b
		   Inner Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
		   Inner Join dbo.transaksiPendaftaranPasienDetail d On a.idPendaftaranPasien = d.idPendaftaranPasien And d.aktif = 1
				Inner Join dbo.masterRuanganTempatTidur da On d.idTempatTidur = da.idTempatTidur
				Inner Join dbo.masterRuanganRawatInap db On da.idRuanganRawatInap = db.idRuanganRawatInap
				Inner Join dbo.masterRuangan dc On db.idRuangan = dc.idRuangan
		   Inner Join dbo.masterHubunganKeluarga e On a.idHubunganKeluargaPenanggungJawab = e.idHubunganKeluarga
		   Inner Join dbo.masterOperator f On a.idDokter = f.idOperator
		   Inner Join dbo.masterKelas g On a.idKelas = g.idKelas
		   Left Join dbo.masterAsalPasien h On a.idAsalPasien = h.idAsalPasien
		   Inner Join dbo.transaksiPendaftaranPasienDetail i On a.idPendaftaranPasien = i.idPendaftaranPasien And i.aktif = 1
				Inner Join dbo.masterUser ia On i.idUserEntry = ia.idUser
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END