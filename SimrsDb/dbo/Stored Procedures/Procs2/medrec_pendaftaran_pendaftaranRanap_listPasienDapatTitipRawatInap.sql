
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listPasienDapatTitipRawatInap]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, h.tglOrder, b.noRM, b.namaPasien, b.umur, b.namaJenisKelamin AS jenisKelamin, c.namaJenisPendaftaran
		  ,b.tglLahirPasien, ea.namaJenisPenjaminInduk, kelasAwal.namaKelas as kelasAwal, kelasNaik.namaKelas as kelasNaik, d.NamaOperator
		  ,ha.namaRuangan		  
	  FROM dbo.transaksiPendaftaranPasien a 
		   LEFT JOIN dbo.masterKelas kelasAwal On a.idKelasPenjaminPembayaran = kelasawal.idKelas
		   LEFT JOIN dbo.masterKelas kelasNaik On a.idKelas = kelasNaik.idKelas
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.masterJenisPendaftaran c On a.idJenisPendaftaran = c.idJenisPendaftaran
		   LEFT JOIN dbo.masterOperator d On a.idDokter = d.idOperator		   
		   LEFT JOIN dbo.masterJenisPenjaminPembayaranPasien e On a.idJenisPenjaminPembayaranPasien = e.idJenisPenjaminPembayaranPasien
				 LEFT JOIN dbo.masterJenisPenjaminPembayaranPasienInduk ea On e.idJenisPenjaminInduk = ea.idJenisPenjaminInduk
		   INNER JOIN dbo.transaksiOrderRawatInap h On a.idPendaftaranPasien = h.idPendaftaranPasien
				LEFT JOIN dbo.masterRuangan ha On h.idRuanganAsal = ha.idRuangan
	 WHERE a.idStatusPendaftaran <= 6/*Belum Pulang*/
  ORDER BY h.tglOrder
END