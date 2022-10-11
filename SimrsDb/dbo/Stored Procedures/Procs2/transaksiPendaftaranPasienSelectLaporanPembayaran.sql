CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanPembayaran]
	
	 @idstatusPendaftaran int

AS
BEGIN

	SET NOCOUNT ON;
 
    SELECT 
	
		-- PASIEN --  
		Substring(b.[kodePasien],1,2)+'.'+Substring(b.[kodePasien],3,2)+'.'+Substring(b.[kodePasien],5,2) as kodePasien
		,Case 
			when b.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (2,3) then  b.namaLengkapPasien + '. NY BINTI ' + b.namaAyahPasien
			when b.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then  b.namaLengkapPasien + '. NN BINTI ' + b.namaAyahPasien
			when b.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then b.namaLengkapPasien + '. AN BINTI ' + b.namaAyahPasien
			when b.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (2,3) then b.namaLengkapPasien + '. TN BIN ' + b.namaAyahPasien
			when b.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then b.namaLengkapPasien + '. TN BIN ' + b.namaAyahPasien
			when b.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then  b.namaLengkapPasien + '. AN BIN ' + b.namaAyahPasien
		End
			as  [namaLengkapPasien],SUM(cb.tarip) as Pembayaran
	FROM [dbo].[transaksiPendaftaranPasien] a
		 Inner join [masterPasien] b on a.[idPasien] = b.[idPasien]
		 Inner Join masterRuanganPelayanan c On a.idRuangan = c.idRuangan
			Inner Join masterTarip ca On c.idMasterPelayanan = ca.idMasterPelayanan
			Inner Join masterTaripDetail cb On ca.idMasterTarif = cb.idMasterTarip
	WHERE a.[idStatusPendaftaran] = @idstatusPendaftaran
	GROUP BY b.[kodePasien],b.idJenisKelaminPasien,b.idStatusPerkawinanPasien,b.namaLengkapPasien,b.tglLahirPasien,b.namaAyahPasien;
END