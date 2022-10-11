-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[get_dataPasien]
(	
	-- Add the parameters for the function here
	@idPasien int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idPasien, a.kodePasien, Substring(a.kodePasien,1,2)+'.'+Substring(a.kodePasien,3,2)+'.'+Substring(a.kodePasien,5,2) As noRM, a.namaLengkapPasien
		  ,Case 
				When a.idJenisKelaminPasien = 2 and a.idStatusPerkawinanPasien in (2,3,5)
					 Then  'Ny. '+ a.namaLengkapPasien + ' BINTI ' + a.namaAyahPasien
				When a.idJenisKelaminPasien = 2 and a.idStatusPerkawinanPasien in (1) And DATEDIFF(hour, a.tglLahirPasien, GETDATE()) <= 720 
					 Then 'By. Ny. '+ a.namaLengkapPasien + ' BINTI ' + a.namaAyahPasien
				When a.idJenisKelaminPasien = 2 and a.idStatusPerkawinanPasien in (1) And DATEDIFF(day, a.tglLahirPasien, GETDATE()) Between 30 And 6204 
					 Then 'An. '+ a.namaLengkapPasien + ' BINTI ' + a.namaAyahPasien
				When a.idJenisKelaminPasien = 2 and a.idStatusPerkawinanPasien in (1) And DATEDIFF(day, a.tglLahirPasien, GETDATE()) > 6204 
					 Then  'Nn. '+ a.namaLengkapPasien + ' BINTI ' + a.namaAyahPasien
				When a.idJenisKelaminPasien = 1 and a.idStatusPerkawinanPasien in (2,3,5) 
					 Then 'Tn. '+ a.namaLengkapPasien + ' BIN ' + a.namaAyahPasien
				When a.idJenisKelaminPasien = 1 and a.idStatusPerkawinanPasien in (1) And DATEDIFF(hour, a.tglLahirPasien, GETDATE()) <= 720 
					 Then 'By. Ny. '+ a.namaLengkapPasien + ' BIN ' + a.namaAyahPasien
				When a.idJenisKelaminPasien = 1 and a.idStatusPerkawinanPasien in (1) And DATEDIFF(day, a.tglLahirPasien, GETDATE()) Between 30 And 6204 
					 Then  'An. '+ a.namaLengkapPasien + ' BIN ' + a.namaAyahPasien
				When a.idJenisKelaminPasien = 1 and a.idStatusPerkawinanPasien in (1) And DATEDIFF(day, a.tglLahirPasien, GETDATE()) > 6204
					 Then 'Tn. '+ a.namaLengkapPasien + ' BIN ' + a.namaAyahPasien
			End As namaPasien
		  ,Case 
				When DATEDIFF(hour,a.tglLahirPasien,GETDATE())/168 = 0
					 Then Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/24) + ' Hari'
				When DATEDIFF(hour,a.tglLahirPasien,GETDATE())/730 = 0 
					 Then Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/168) + ' Minggu'
				When DATEDIFF(hour,a.tglLahirPasien,GETDATE())/8766 = 0 
					 Then Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/730) + ' Bulan'
				Else Convert(nvarchar(50),DATEDIFF(hour,a.tglLahirPasien,GETDATE())/8766) + ' Tahun'
			End As umur
		  ,b.idJenisKelamin, b.namaJenisKelamin, a.tempatLahirPasien, a.tglLahirPasien, alamatPasien, c.namaDesaKelurahan, ca.namaKecamatan
		  ,cb.namaKabupaten, cc.namaProvinsi, a.noDokumenIdentitasPasien, a.noBPJS, d.namaAgama, a.namaAyahPasien, a.namaIbuPasien, e.namaPendidikan, f.namaPekerjaan, g.namaWargaNegara
		  ,h.namaStatusPerkawinan, a.catatanKesehatan, a.noHpPasien1, a.noHPPasien2
	  FROM dbo.masterPasien a 
		   Inner Join dbo.masterJenisKelamin b On a.idJenisKelaminPasien = b.idJenisKelamin
		   Left Join dbo.masterDesaKelurahan c On a.idDesaKelurahanPasien = c.idDesaKelurahan
				Left Join dbo.masterKecamatan ca On c.idKecamatan = ca.idKecamatan
				Left Join dbo.masterKabupaten cb On ca.idKabupaten = cb.idKabupaten
				Left Join dbo.masterProvinsi cc On cb.idProvinsi = cc.idProvinsi
		   Inner Join dbo.masterAgama d On a.idAgamaPasien = d.idAgama
		   Left Join dbo.masterPendidikan e On a.idPendidikanPasien = e.idPendidikan
		   Left Join dbo.masterPekerjaan f On a.idPekerjaanPasien = f.idPekerjaan
		   Left Join dbo.masterWargaNegara g On a.idWargaNegaraPasien = g.idWargaNegara
		   Left Join dbo.masterStatusPerkawinan h On a.idStatusPerkawinanPasien = h.idStatusPerkawinan
	 WHERE a.idPasien = @idPasien
)