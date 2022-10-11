CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_cetakStatusDataPasien]
	 @idPendaftaranPasien bigint
AS
BEGIN

	SET NOCOUNT ON;

	SELECT b.kodePasien, b.noRM, b.namaDokumenIdentitas AS namaIdentitas, b.namaPasien, b.namaJenisKelamin, b.umur, b.tglLahirPasien, b.tempatLahirPasien, b.noDokumenIdentitasPasien, b.namaAgama
		  ,b.namaPendidikan, b.namaPekerjaan, b.namaIbuPasien, b.namaAyahPasien, b.namaWargaNegara, b.namaStatusPerkawinan, b.catatanKesehatan
		  ,b.alamatPasien, b.namaDesaKelurahan, b.namaKecamatan, b.namaKabupaten, b.noHpPasien1, b.noHpPasien2
	  FROM dbo.transaksiPendaftaranPasien a
		   Outer Apply dbo.getinfo_datapasien(a.idPasien) b
     WHERE a.idPendaftaranPasien = @idPendaftaranPasien

END