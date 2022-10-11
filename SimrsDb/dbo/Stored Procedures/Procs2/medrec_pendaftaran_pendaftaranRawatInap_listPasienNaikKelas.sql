
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRawatInap_listPasienNaikKelas]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT h.idPendaftaranPasien, a.idPasien, h.idStatusOrderRawatInap, h.tglOrder, d.noPenjamin, a.noSEPRawatInap AS noSEP
		  ,d.kodePasien, d.noRM, d.namaPasien, d.umur, d.namaJenisKelamin, c.namaJenisPendaftaran, a.tglDaftarPasien
		  ,d.tglLahirPasien, e.penjamin AS namaJenisPenjaminInduk, ha.alias AS namaRuangan, gc.Alias +' ('+ gb.namaRuanganRawatInap +')' AS ruanganTujuan
		  ,e.idJenisPenjaminInduk, kelasAwal.namaKelas as kelasAwal,kelasNaik.namaKelas AS kelasNaik
		  ,a.flagBerkasTidakLengkap
	  FROM dbo.transaksiPendaftaranPasien a 
		   LEFT JOIN dbo.masterKelas kelasAwal On a.idKelasPenjaminPembayaran = kelasawal.idKelas
		   LEFT JOIN dbo.masterKelas kelasNaik On a.idKelasPenjaminPembayaran - 1 = kelasNaik.idKelas
		   LEFT JOIN dbo.masterJenisPendaftaran c On a.idJenisPendaftaran = c.idJenisPendaftaran
		   OUTER APPLY dbo.getinfo_datapasien(a.idPasien) d
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) e
		   LEFT JOIN dbo.transaksiOrderRawatInap h On a.idPendaftaranPasien = h.idPendaftaranPasien
				LEFT JOIN dbo.masterRuangan ha On h.idRuanganAsal = ha.idRuangan
		   INNER JOIN dbo.transaksiPendaftaranPasienDetail g On a.idPendaftaranPasien = g.idPendaftaranPasien And g.aktif = 1/*Aktif*/
				Left Join dbo.masterRuanganTempatTidur ga On g.idTempatTidur = ga.idTempatTidur
				Left Join dbo.masterRuanganRawatInap gb On ga.idRuanganRawatInap = gb.idRuanganRawatInap
				Left Join dbo.masterRuangan gc On gb.idRuangan = gc.idRuangan
	 WHERE g.idStatusPendaftaranRawatInap = 3/*Naik Kelas*/ AND a.idStatusPendaftaran < 99/*Belum Pulang*/
  ORDER BY a.tglEntry
END