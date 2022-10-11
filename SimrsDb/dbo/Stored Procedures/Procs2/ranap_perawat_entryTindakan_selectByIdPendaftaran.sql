
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_selectByIdPendaftaran]
	 @idPendaftaranPasien bigint

AS
BEGIN

	SET NOCOUNT ON;
	SELECT a.idPendaftaranPasien, b.idPasien, a.tglDaftarPasien, a.anamnesa, d.idJenisPelayananRawatInap
		   --DATA PASIEN
		  ,b.kodePasien, b.noRM, b.namaPasien, b.alamatPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur
		   --PENJAMIN PEMBAYARAN
		  ,c.namaJenisPenjaminPembayaranPasien
		   --PENANGGUNG JAWAB
		  ,a.namaPenanggungJawabPasien, a.idHubunganKeluargaPenanggungJawab, a.alamatPenanggungJawabPasien
		  ,a.noHpPenanggungJawab
		   --data rawat Inap
		  ,a.tglDaftarPasien As tglDaftarRawatInap, d.ruanganInap AS namaRuanganRawatInap, a.idDokter, d.idRuanganRawatInap, d.idTempatTidur, d.idRuangan, f.NamaOperator AS DPJP
		  ,d.kamarInap AS noTempatTidur, g.idKelas, g.namaKelas As kelasPenjaminPasien, f.idOperator, f.NamaOperator
		  ,CASE
				WHEN e.idTransaksiOrderOK IS NOT NULL
					 THEN 1
				ELSE 0
		    END AS flagOrderOK
		  ,CASE
				WHEN EXISTS(SELECT TOP 1 1 FROM dbo.transaksiDiagnosaPasien WHERE idPendaftaranPasien = @idPendaftaranPasien)
					 THEN 1
				ELSE 0
		    END AS flagDiagnosa
			--alergi
			,a.jenisDiet, a.keteranganDiet
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
		   OUTER APPLY dbo.getInfo_dataRawatInap(a.idPendaftaranPasien) d
		   LEFT JOIN dbo.transaksiOrderOK e ON a.idPendaftaranPasien = e.idPendaftaranPasien
		   LEFT JOIN dbo.masterOperator f On a.idDokter = f.idOperator
		   LEFT JOIN dbo.masterKelas g On a.idKelas = g.idKelas
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien

END