-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gizi_layananKonsumsi_dashboard_listOrder]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.idPendaftaranPasien, b.idPasien, a.[tglDaftarPasien], b.kodePasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin
		  ,b.tglLahirPasien, b.umur, db.namaKelas As kelasPenjaminPasien, c.idJenisPenjaminInduk, c.namaJenisPenjaminPembayaranPasien
		  --PENANGGUNG JAWAB
		  ,a.namaPenanggungJawabPasien, a.idHubunganKeluargaPenanggungJawab, a.alamatPenanggungJawabPasien, a.noHpPenanggungJawab
		  --PENDAFTARAN
		  ,f.[namaStatusPendaftaran], g.[namaJenisPendaftaran], a.noSEPRawatInap AS noSEP, eb.namaRuanganRawatInap, ea.noTempatTidur
		  ,a.keteranganDiet, a.jenisDiet, '' AS alergiDiet, e.tanggalMasuk AS tglPendaftaranRanap
		  --DIAGNOSA
		  ,h.diagnosa AS diagnosaAwal, d.idOperator, d.NamaOperator, a.idDokter As idDPJP, d.NamaOperator As DPJP
		  ,ec.namaRuangan
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   INNER JOIN dbo.masterJenisPenjaminPembayaranPasien c ON a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
		   INNER JOIN dbo.masterOperator d ON a.idDokter = d.idOperator
				LEFT JOIN dbo.masterKelas db ON a.idKelasPenjaminPembayaran = db.idKelas
		   INNER JOIN dbo.transaksiPendaftaranPasienDetail e ON a.idPendaftaranPasien = e.idPendaftaranPasien AND e.aktif = 1/*true*/
				INNER JOIN dbo.masterRuanganTempatTidur ea ON e.idTempatTidur = ea.idTempatTidur
				INNER JOIN dbo.masterRuanganRawatInap eb ON ea.idRuanganRawatInap = eb.idRuanganRawatInap
				INNER JOIN [dbo].[masterRuangan] ec on eb.[idRuangan] = ec.[idRuangan]
		   INNER JOIN [dbo].[masterStatusPendaftaran] f on a.[idStatusPendaftaran] = f.[idStatusPendaftaran]
		   INNER JOIN [dbo].[masterJenisPendaftaran] g on a.[idJenisPendaftaran] = g.[idJenisPendaftaran]
		   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) h
	 WHERE a.idJenisPerawatan = 1/*Rawat Inap*/ AND a.idStatusPendaftaran = 5/*Dalam Perawatan Rawat Inap*/
		   AND NULLIF(TRIM(a.keteranganDiet), '') IS NULL AND a.idKelas <> 7/*Neonatus*/
  ORDER BY ec.namaRuangan, e.tanggalMasuk DESC;
END