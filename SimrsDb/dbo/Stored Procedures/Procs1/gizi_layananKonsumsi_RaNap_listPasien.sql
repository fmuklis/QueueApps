-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gizi_layananKonsumsi_RaNap_listPasien]
	-- Add the parameters for the stored procedure here
	@tanggalKonsumsi date,
	@idJadwalKonsumsi tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.idPendaftaranPasien, h.idLayananGiziPasien
		  ,(Select MIN(xa.tanggalMasuk)
			  From dbo.transaksiPendaftaranPasienDetail xa
			 Where a.idPendaftaranPasien = xa.idPendaftaranPasien) As tglDaftarPasien
		  ,b.kodePasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin
		  ,b.tglLahirPasien, b.umur
		  ,a.idJenisPenjaminPembayaranPasien, db.namaKelas As kelasPenjaminPasien
		  ,c.idJenisPenjaminInduk, c.namaJenisPenjaminPembayaranPasien
		  ,a.namaPenanggungJawabPasien, a.idHubunganKeluargaPenanggungJawab, a.alamatPenanggungJawabPasien, a.noHpPenanggungJawab
		  ,f.[namaStatusPendaftaran], g.[namaJenisPendaftaran], a.noSEPRawatInap AS noSEP, eb.namaRuanganRawatInap, ea.idTempatTidur, ea.noTempatTidur
		  ,a.keteranganDiet, a.jenisDiet, e.tanggalMasuk As tglDaftarRanap, ec.namaRuangan
		  ,i.diagnosa AS diagnosaAwal, d.idOperator, d.NamaOperator, a.idDokter As idDPJP, d.NamaOperator As DPJP
		  ,STRING_AGG(j.alergiPasien, '|') AS alergiDiet, @idJadwalKonsumsi AS idJadwalKonsumsi
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   INNER JOIN dbo.masterJenisPenjaminPembayaranPasien c on a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
		   INNER JOIN dbo.masterOperator d On a.idDokter = d.idOperator
		   LEFT JOIN dbo.masterKelas db On a.idKelasPenjaminPembayaran = db.idKelas
		   INNER JOIN dbo.transaksiPendaftaranPasienDetail e On a.idPendaftaranPasien = e.idPendaftaranPasien And e.aktif = 1/*true*/
				INNER JOIN dbo.masterRuanganTempatTidur ea On e.idTempatTidur = ea.idTempatTidur
				INNER JOIN dbo.masterRuanganRawatInap eb On ea.idRuanganRawatInap = eb.idRuanganRawatInap
				INNER JOIN dbo.masterRuangan ec On eb.idRuangan = ec.idRuangan
		   INNER JOIN dbo.masterStatusPendaftaran f on a.idStatusPendaftaran = f.idStatusPendaftaran
		   INNER JOIN dbo.masterJenisPendaftaran g on a.idJenisPendaftaran = g.idJenisPendaftaran
		   LEFT JOIN dbo.layananGiziPasien h On a.idPendaftaranPasien = h.idPendafaranPasien And h.idJadwalKonsumsi = @idJadwalKonsumsi AND h.tanggalKonsumsi = @tanggalKonsumsi
		   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) i
		   LEFT JOIN dbo.masterPasienAlergi j ON a.idPasien = j.idPasien AND j.idJenisAlergi = 2/*alergi makanan*/
	 WHERE a.idJenisPerawatan = 1/*Rawat Inap*/ AND LEN(a.keteranganDiet) >= 3/*Sudah Di Approv Gizi*/ AND a.idStatusPendaftaran in(5,6)/*Dalam Perawatan RaNap*/
  GROUP BY a.idPendaftaranPasien, h.idLayananGiziPasien, a.tglDaftarPasien
		  ,b.kodePasien, b.noRM, b.namaPasien, b.namaJenisKelamin
		  ,b.tglLahirPasien, b.umur
		  ,a.idJenisPenjaminPembayaranPasien, db.namaKelas
		  ,c.idJenisPenjaminInduk, c.namaJenisPenjaminPembayaranPasien
		  ,a.namaPenanggungJawabPasien, a.idHubunganKeluargaPenanggungJawab, a.alamatPenanggungJawabPasien, a.noHpPenanggungJawab
		  ,f.[namaStatusPendaftaran], g.[namaJenisPendaftaran], a.noSEPRawatInap, eb.namaRuanganRawatInap, ea.idTempatTidur, ea.noTempatTidur
		  ,a.keteranganDiet, a.jenisDiet, e.tanggalMasuk, ec.namaRuangan
		  ,i.diagnosa, d.idOperator, d.NamaOperator, a.idDokter, d.NamaOperator
		  ,idJadwalKonsumsi
  ORDER BY ec.namaRuangan, a.tglDaftarPasien DESC, b.namaPasien;		    
END