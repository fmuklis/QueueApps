
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listPasienRawatinap]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.idPendaftaranPasien, a.idPasien, h.tglOrder, a.tglDaftarPasien, j.tanggalMasukRawatInap, j.tanggalMasuk, d.kodePasien, d.noRM, d.noPenjamin
		  ,d.namaPasien, d.umur, d.namaJenisKelamin, c.namaJenisPendaftaran, d.tglLahirPasien, g.namaKelas, ha.namaRuangan, j.kamarInap AS tujuan
		  ,h.idStatusOrderRawatInap, b.jenisPasien AS namaJenisPenjaminPembayaranPasien, b.penjamin AS namaJenisPenjaminInduk, a.flagBerkasTidakLengkap
		  ,a.noSEPRawatInap AS noSEP, b.idJenisPenjaminInduk, a.idJenisPenjaminPembayaranPasien
		  ,IIF(a.idJenisPerawatan = 1/*ranap*/, 1, 0) AS cetakForm,
		  dbo.calculatorUmur(d.tglLahirPasien,a.tglDaftarPasien) as Umur
	  FROM dbo.transaksiPendaftaranPasien a 
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) b
		   LEFT JOIN dbo.masterJenisPendaftaran c On a.idJenisPendaftaran = c.idJenisPendaftaran
		   OUTER APPLY dbo.getinfo_datapasien(a.idPasien) d
		   Inner Join dbo.masterKelas g On a.idKelas = g.idKelas
		   Inner Join dbo.transaksiOrderRawatInap h On a.idPendaftaranPasien = h.idPendaftaranPasien
				Inner Join dbo.masterRuangan ha On h.idRuanganAsal = ha.idRuangan
		   OUTER APPLY dbo.getInfo_dataRawatInap(a.idPendaftaranPasien) j
	 WHERE a.idStatusPendaftaran < 98 AND (j.idPendaftaranPasienDetail IS NULL OR (j.idStatusPendaftaranRawatInap = 1/*Sesuai Dg Kelas*/ AND a.idPendaftaranIbu IS NULL))
  ORDER BY h.idStatusOrderRawatInap, h.tglOrder

END