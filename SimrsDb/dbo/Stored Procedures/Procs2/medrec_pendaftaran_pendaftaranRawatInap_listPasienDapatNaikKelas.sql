
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRawatInap_listPasienDapatNaikKelas]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, b.noRM, b.namaPasien, b.umur, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien
		  ,ea.namaJenisPenjaminInduk, d.NamaOperator
		  ,CASE
				WHEN gc.idRuangan Is Null
					 THEN ha.alias
				ELSE gc.alias +' ('+ gb.namaRuanganRawatInap +')'
			END AS ruanganTujuan		  
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.masterOperator d On a.idDokter = d.idOperator		   
		   INNER JOIN dbo.masterJenisPenjaminPembayaranPasien e On a.idJenisPenjaminPembayaranPasien = e.idJenisPenjaminPembayaranPasien
				 INNER JOIN dbo.masterJenisPenjaminPembayaranPasienInduk ea On e.idJenisPenjaminInduk = ea.idJenisPenjaminInduk
		   LEFT JOIN dbo.transaksiOrderRawatInap h On a.idPendaftaranPasien = h.idPendaftaranPasien
				LEFT JOIN dbo.masterRuangan ha On h.idRuanganAsal = ha.idRuangan
				LEFT JOIN dbo.transaksiOrderRawatInapPindahKamar hb ON h.idTransaksiOrderRawatInap = hb.idTransaksiOrderRawatInap AND hb.flagStatus = 0/*Belum Di Pindah*/
		   LEFT JOIN dbo.transaksiPendaftaranPasienDetail g On h.idPendaftaranPasien = g.idPendaftaranPasien And g.aktif = 1
				LEFT JOIN dbo.masterRuanganTempatTidur ga On g.idTempatTidur = ga.idTempatTidur
				LEFT JOIN dbo.masterRuanganRawatInap gb On ga.idRuanganRawatInap = gb.idRuanganRawatInap
				LEFT JOIN dbo.masterRuangan gc On gb.idRuangan = gc.idRuangan
	 WHERE e.idJenisPenjaminInduk = 2/*BPJS*/ And a.idStatusPendaftaran <= 98/*Belum Pulang*/
		   AND ((ISNULL(g.idStatusPendaftaranRawatInap, 3) <> 3/*BPJS Naik Kelas*/ AND hb.idOrderPindahKamar IS NOT NULL) OR h.idStatusOrderRawatInap = 1/*Order Rawat Inap*/)
  ORDER BY g.tanggalMasuk, h.tglOrder
END