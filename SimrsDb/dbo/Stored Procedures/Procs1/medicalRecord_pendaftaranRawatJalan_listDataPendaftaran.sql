-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medicalRecord_pendaftaranRawatJalan_listDataPendaftaran]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   SELECT a.idPasien, a.idPendaftaranPasien, a.idStatusPendaftaran, f.idJenisPenjaminInduk, a.tglDaftarPasien, b.noRM, b.kodePasien, b.namaPasien
		 ,b.namaJenisKelamin, b.tglLahirPasien, d.namaStatusPendaftaran, fa.namaJenisPenjaminInduk, b.jumlahCetak, b.cetakKartu, e.namaRuangan
		 ,a.flagBerkasTelahDikirim, g.NamaOperator, a.flagBerkasTidakLengkap, a.noSEPRawatJalan AS noSEP, b.noPenjamin
	 FROM dbo.transaksiPendaftaranPasien a 
		  OUTER APPLY dbo.getinfo_datapasien(a.idPasien) b
		  LEFT JOIN dbo.masterStatusPendaftaran d On a.idStatusPendaftaran = d.idStatusPendaftaran
		  LEFT JOIN dbo.masterRuangan e On a.idRuangan = e.idRuangan
		  LEFT JOIN dbo.masterJenisPenjaminPembayaranPasien f On a.idJenisPenjaminPembayaranPasien = f.idJenisPenjaminPembayaranPasien
				LEFT JOIN dbo.masterJenisPenjaminPembayaranPasienInduk fa On f.idJenisPenjaminInduk = fa.idJenisPenjaminInduk
		  LEFT JOIN dbo.masterOperator g On a.idDokter = g.idOperator
	WHERE a.idJenisPendaftaran = 2/*RaJal*/ and a.idJenisPerawatan = 2/*Rajal*/ And (a.idStatusPendaftaran < 99 Or (a.idStatusPendaftaran > 99 And Convert(date, a.tglDaftarPasien) = Convert(date, GetDate())))
 ORDER BY a.tglDaftarPasien DESC;
END