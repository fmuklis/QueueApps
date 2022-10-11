-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 09/11/2018
-- Description:	Menampilkan Format Data Pasien 
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_dataPasien]
(
	-- Add the parameters for the function here
	@idPasien int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idPasien, a.kodePasien, SUBSTRING(a.kodePasien,1,2) +'.'+ SUBSTRING(a.kodePasien,3,2) +'.'+ SUBSTRING(a.kodePasien,5,2) AS noRM, a.namaLengkapPasien
		  ,cc.idProvinsi, cb.idKabupaten, ca.idKecamatan, c.idDesaKelurahan, a.anakKePasien, e.idAgama AS idAgamaPasien, f.idStatusPerkawinan AS idStatusPerkawinanPasien
		  ,j.namaPasien
		  ,Case 
				When DATEDIFF(hour,a.tglLahirPasien,GETDATE())/168 = 0
					 Then Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/24) + ' Hari'
				When DATEDIFF(hour,a.tglLahirPasien,GETDATE())/730 = 0 
					 Then Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/168) + ' Minggu'
				When DATEDIFF(hour,a.tglLahirPasien,GETDATE())/8766 = 0 
					 Then Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/730) + ' Bulan'
				Else Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/8766) + ' Tahun'
			End As umur
		  ,b.idJenisKelamin, b.namaJenisKelamin, a.beratLahir AS bobotLahir, a.tglLahirPasien, h.namaDokumenIdentitas, a.noDokumenIdentitasPasien, a.noBPJS AS noPenjamin
		  ,c.namaDesaKelurahan, ca.namaKecamatan, cb.namaKabupaten, cc.namaProvinsi, cc.idNegara, cd.namaNegara, d.namaPekerjaan, e.namaAgama, f.namaStatusPerkawinan, g.namaWargaNegara
		  ,i.namaPendidikan, a.jumlahCetak, a.cetakKartu, a.tempatLahirPasien, a.catatanKesehatan,namaIbuPasien,namaAyahPasien, a.noHpPasien1, a.noHpPasien2
		  ,a.alamatPasien +' Ds. '+ c.namaDesaKelurahan +' Kec. '+ ca.namaKecamatan +' Kab. '+ cb.namaKabupaten AS alamatLengkap, a.alamatPasien
	  FROM dbo.masterPasien a 
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
		   OUTER APPLY dbo.generate_namaPasien(a.tglLahirPasien, GETDATE(), a.idJenisKelaminPasien, a.idStatusPerkawinanPasien, a.namaLengkapPasien, a.namaAyahPasien) j
	 WHERE a.idPasien = @idPasien
)