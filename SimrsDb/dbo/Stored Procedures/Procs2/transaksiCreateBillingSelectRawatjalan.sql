CREATE PROCEDURE [dbo].[transaksiCreateBillingSelectRawatjalan]
	@idStatusPendaftaran int
as
Begin
	set nocount on;




	Select a.idBilling,a.idPendaftaranPasien ,d.kodePasien,substring(d.kodePasien,1,2) + '.' + substring(d.kodePasien,3,2) + '.' + substring(d.kodePasien,5,2)  as noRM,
	case 
	when d.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (2,3) then  d.namaLengkapPasien + '. NY BINTI ' + d.namaAyahPasien
	when d.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then  d.namaLengkapPasien + '. NN BINTI ' + d.namaAyahPasien
	when d.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then  d.namaLengkapPasien + '. AN BINTI ' + d.namaAyahPasien
	
	when d.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (2,3) then d.namaLengkapPasien + '. TN BIN ' + d.namaAyahPasien
	when d.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then d.namaLengkapPasien + '. TN BIN ' + d.namaAyahPasien
	when d.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then  d.namaLengkapPasien + '. AN BIN ' + d.namaAyahPasien
	
		End
		as  [namaLengkapPasien]
	,c.namaPenanggungJawabPasien,d.tglLahirPasien,DATEDIFF(hour,tglLahirPasien,GETDATE())/8766 AS Umur
	,e.namaJenisKelamin,f.namaJenisPendaftaran
	,b.total from transaksiBillingHeader a
	inner join (select idbilling,sum(nilai * jumlah) as total from transaksiBillingDetail group by idBilling) b on a.idBilling = b.idBilling
	inner join transaksiPendaftaranPasien c on a.idPendaftaranPasien = c.idPendaftaranPasien
	inner join masterPasien d on c.idPasien = d.idPasien
	inner join masterJenisKelamin e on d.idJenisKelaminPasien = e.idJenisKelamin
	inner join masterJenisPendaftaran f on c.idJenisPendaftaran = f.idJenisPendaftaran
	where c.idStatusPendaftaran = @idStatusPendaftaran;
End