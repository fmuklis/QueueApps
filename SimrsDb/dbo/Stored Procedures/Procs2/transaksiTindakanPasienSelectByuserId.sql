CREATE PROCEDURE [dbo].[transaksiTindakanPasienSelectByuserId]
	@idUserEntry int
as
Begin

	set nocount on
select a.idpasien,substring(a.kodePasien,1,2) + '.' + substring(a.kodePasien,3,2) + '.' + substring(a.kodePasien,5,2)  as noRm, 
case 
	when a.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (2,3) then  a.namaLengkapPasien + '. NY BINTI ' + a.namaAyahPasien
	when a.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then  a.namaLengkapPasien + '. NN BINTI ' + a.namaAyahPasien
	when a.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then  a.namaLengkapPasien + '. AN BINTI ' + a.namaAyahPasien
	
	when a.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (2,3) then a.namaLengkapPasien + '. TN BIN ' + a.namaAyahPasien
	when a.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then a.namaLengkapPasien + '. TN BIN ' + a.namaAyahPasien
	when a.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then  a.namaLengkapPasien + '. AN BIN ' + a.namaAyahPasien
	
End
as namaLengkapPasien
,a.tglLahirPasien, DATEDIFF(hour,tglLahirPasien,GETDATE())/8766 AS Umur,d.namaJenisKelamin,e.namaJenisPendaftaran as jenisDaftar from masterPasien a
	inner join transaksiPendaftaranPasien b on a.idPasien = b.idPasien
	inner join transaksiTindakanPasien c on b.idPendaftaranPasien = c.idPendaftaranPasien
	inner join masterJenisKelamin d on a.idJenisKelaminPasien = d.idJenisKelamin
	inner join masterJenisPendaftaran e on b.idJenisPendaftaran = e.idJenisPendaftaran
	where c.idUserEntry = @idUserEntry
	group by  a.idpasien,a.kodePasien,a.namaLengkapPasien,a.idJenisKelaminPasien,a.namaAyahPasien, a.idStatusPerkawinanPasien, tglLahirPasien,d.namaJenisKelamin,e.namaJenisPendaftaran;
End