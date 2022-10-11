
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listPasienTitipRawatInap]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.idPasien, h.idStatusOrderRawatInap, h.tglOrder, a.tglDaftarPasien, d.kodePasien, d.noRM, d.namaPasien, d.umur
		  ,d.namaJenisKelamin, c.namaJenisPendaftaran, d.tglLahirPasien, e.penjamin AS namaJenisPenjaminInduk, ha.namaRuangan, a.flagBerkasTidakLengkap
		  ,gc.Alias +' ('+ gb.namaRuanganRawatInap +')' As ruanganTujuan, e.idJenisPenjaminInduk, d.noPenjamin, a.noSEPRawatInap AS noSEP
	  FROM dbo.transaksiPendaftaranPasien a 
		   LEFT JOIN dbo.masterJenisPendaftaran c On a.idJenisPendaftaran = c.idJenisPendaftaran
		   OUTER APPLY dbo.getinfo_datapasien(a.idPasien) d
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) e
		   INNER JOIN dbo.transaksiOrderRawatInap h On a.idPendaftaranPasien = h.idPendaftaranPasien
				INNER JOIN dbo.masterRuangan ha On h.idRuanganAsal = ha.idRuangan
		   INNER JOIN dbo.transaksiPendaftaranPasienDetail g On h.idPendaftaranPasien = g.idPendaftaranPasien And g.aktif = 1
				Left Join dbo.masterRuanganTempatTidur ga On g.idTempatTidur = ga.idTempatTidur
				Left Join dbo.masterRuanganRawatInap gb On ga.idRuanganRawatInap = gb.idRuanganRawatInap
				Left Join dbo.masterRuangan gc On gb.idRuangan = gc.idRuangan
	 WHERE g.idStatusPendaftaranRawatInap = 2/*Titip Kamar*/ And a.idStatusPendaftaran < 99
  ORDER BY g.tanggalEntry
END