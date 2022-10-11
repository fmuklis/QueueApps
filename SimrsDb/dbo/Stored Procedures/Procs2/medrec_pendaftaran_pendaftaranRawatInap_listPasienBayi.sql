-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRawatInap_listPasienBayi]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.idPasien, b.kodePasien, b.noRM, b.namaPasien, b.namaJenisKelamin, b.tglLahirPasien, b.umur, d.penjamin AS namaJenisPenjaminInduk
		  ,c.kamarInap As namaRuangan, b.noPenjamin, a.noSEPRawatInap AS noSEP
		  ,a.tanggalRawatInap AS tanggalMasuk, d.idJenisPenjaminInduk, e.idStatusOrderRawatInap, e.tglOrder, a.flagBerkasTidakLengkap, a.tglDaftarPasien
		  ,CASE
				WHEN a.idKelas = 7/*Neonatus*/
					 THEN 1
				ELSE 0
			END AS perinatal
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getinfo_datapasien(a.idPasien) b
		   OUTER APPLY dbo.getInfo_dataRawatInap(a.idPendaftaranPasien) c
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) d
		   INNER JOIN dbo.transaksiOrderRawatInap e On a.idPendaftaranPasien = e.idPendaftaranPasien
	 WHERE a.idPendaftaranIbu IS NOT NULL AND a.idStatusPendaftaran < 99
  ORDER BY a.tglEntry DESC
END