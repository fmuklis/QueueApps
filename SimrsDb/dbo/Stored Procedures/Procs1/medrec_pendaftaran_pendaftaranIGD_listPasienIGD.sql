-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranIGD_listPasienIGD]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   Select a.idPasien, a.idPendaftaranPasien, a.idStatusPendaftaran, f.idJenisPenjaminInduk, a.tglDaftarPasien, b.noRM, b.kodePasien, b.namaPasien
		 ,b.namaJenisKelamin, b.tglLahirPasien, d.namaStatusPendaftaran, fa.namaJenisPenjaminInduk, b.jumlahCetak, b.cetakKartu
		 ,a.flagBerkasTelahDikirim, g.NamaOperator, a.flagBerkasTidakLengkap, a.noSEPRawatJalan AS noSEP, b.noPenjamin
	 From transaksiPendaftaranPasien a 
		  Cross Apply dbo.getinfo_datapasien(a.idPasien) b
		  Inner Join dbo.masterStatusPendaftaran d On a.idStatusPendaftaran = d.idStatusPendaftaran
		  Inner Join dbo.masterJenisPenjaminPembayaranPasien f On a.idJenisPenjaminPembayaranPasien = f.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk fa On f.idJenisPenjaminInduk = fa.idJenisPenjaminInduk
		  Inner Join dbo.masterOperator g On a.idDokter = g.idOperator
	Where a.idJenisPendaftaran = 1/*IGD*/ and a.idJenisPerawatan = 2/*Rajal*/ And (a.idStatusPendaftaran < 99 Or (a.idStatusPendaftaran > 99 And Convert(date, a.tglDaftarPasien) = Convert(date, GetDate())))
 Order By a.tglDaftarPasien DESC;
END