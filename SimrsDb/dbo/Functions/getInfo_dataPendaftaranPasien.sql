-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- CREATE date: 09/11/2018
-- Description:	Menampilkan Format Data Pasien 
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_dataPendaftaranPasien]
(
	-- Add the parameters for the function here
	@idPendaftaranPasien bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idPasien, a.kodePasien, SUBSTRING(a.kodePasien, 1, 2) +'.'+ SUBSTRING(a.kodePasien, 3, 2) +'.'+ SUBSTRING(a.kodePasien, 5, 2) AS noRM, a.namaLengkapPasien
		  ,cd.idNegara, cc.idProvinsi, cb.idKabupaten, ca.idKecamatan, c.idDesaKelurahan, a.anakKePasien, e.idAgama AS idAgamaPasien
		  ,f.idStatusPerkawinan AS idStatusPerkawinanPasien, a.gelarDepanPasien, a.gelarBelakangPasien, j.namaPasien, k.detailUmur AS umur
		  ,b.idJenisKelamin, b.namaJenisKelamin, b.namaJenisKelamin AS jenisKelamin, a.beratLahir AS bobotLahir, a.tglLahirPasien, h.namaDokumenIdentitas
		  ,a.idDokumenIdentitasPasien, a.noDokumenIdentitasPasien, a.noBPJS, c.namaDesaKelurahan, ca.namaKecamatan, cb.namaKabupaten, cc.namaProvinsi
		  ,a.idPekerjaanPasien, d.namaPekerjaan, e.namaAgama, f.namaStatusPerkawinan, a.idWargaNegaraPasien, g.namaWargaNegara
		  ,a.idPendidikanPasien, i.namaPendidikan, a.jumlahCetak, a.cetakKartu, a.tempatLahirPasien, a.catatanKesehatan,namaIbuPasien,namaAyahPasien, a.noHpPasien1, a.noHpPasien2
		  ,a.alamatPasien +' Ds. '+ c.namaDesaKelurahan +' Kec. '+ ca.namaKecamatan +' Kab. '+ cb.namaKabupaten AS alamatPasien, cd.namaNegara
		  ,CASE
				WHEN reg.idJenisPerawatan = 1/*RaNap*/
					 THEN reg.noSEPRawatInap
				ELSE reg.noSEPRawatJalan
			END AS noSEP
	  FROM dbo.masterPasien a 
		   INNER JOIN dbo.transaksiPendaftaranPasien reg ON a.idPasien = reg.idPasien
		   LEFT JOIN dbo.masterJenisKelamin b ON a.idJenisKelaminPasien = b.idJenisKelamin
		   LEFT JOIN dbo.masterDesaKelurahan c ON a.idDesaKelurahanPasien = c.idDesaKelurahan
				LEFT JOIN dbo.masterKecamatan ca ON c.idKecamatan = ca.idKecamatan
				LEFT JOIN dbo.masterKabupaten cb ON ca.idKabupaten = cb.idKabupaten
				LEFT JOIN dbo.masterProvinsi cc ON cb.idProvinsi = cc.idProvinsi
				LEFT JOIN dbo.masterNegara cd ON cc.idNegara = cd.idNegara
		   LEFT JOIN dbo.masterPekerjaan d ON a.idPekerjaanPasien = d.idPekerjaan
		   LEFT JOIN dbo.masterAgama e ON a.idAgamaPasien = e.idAgama
		   LEFT JOIN dbo.masterStatusPerkawinan f ON a.idStatusPerkawinanPasien = f.idStatusPerkawinan
		   LEFT JOIN dbo.masterWargaNegara g ON a.idWargaNegaraPasien = g.idWargaNegara
		   LEFT JOIN dbo.masterDokumenIdentitas h ON a.idDokumenIdentitasPasien = h.idDokumenIdentitas
		   LEFT JOIN dbo.masterPendidikan i ON a.idPendidikanPasien = i.idPendidikan
		   OUTER APPLY dbo.generate_namaPasien(a.tglLahirPasien, reg.tglDaftarPasien, a.idJenisKelaminPasien, a.idStatusPerkawinanPasien, a.namaLengkapPasien, a.namaAyahPasien) j
		   OUTER APPLY dbo.calculator_umur(a.tglLahirPasien, reg.tglDaftarPasien) k
	 WHERE reg.idPendaftaranPasien = @idPendaftaranPasien
)