
CREATE PROC [dbo].[rajal_perawatPoli_entryTindakan_listPasienUntukTransaksiKonsul]	
	 @idTransaksiKonsul int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT dbo.diagnosaPasien(b.idPendaftaranPasien) As diagnosaAwal
		  ,b.idPendaftaranPasien ,ba.namaJenisPenjaminPembayaranPasien ,bc.namaKelas as kelasPenjaminPasien
		  ,be.noRM, be.namaPasien, be.tglLahirPasien, be.umur, be.namaJenisKelamin AS jenisKelamin
		  ,g.namaRuangan as asalRuanganPasien
		  ,b.tglDaftarPasien
		  ,bb.idOperator ,bb.NamaOperator ,f.namaKelas as kelasPelayanan
		  ,a.idTransaksiKonsul, a.idTransaksiKonsul, a.alasan, a.itemKonsul, a.jawaban, a.anjuran
	  FROM dbo.transaksiKonsul a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasien ba On b.idJenisPenjaminPembayaranPasien = ba.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterKelas bc On b.idKelas = bc.idKelas
				Left Join dbo.masterJenisPenjaminPembayaranPasienInduk bd On ba.idJenisPenjaminInduk = bd.idJenisPenjaminInduk
				Left Join dbo.masterOperator bb On b.idDokter = bb.idOperator
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) be
		   Left Join dbo.masterKelas f On b.idKelasPenjaminPembayaran = f.idKelas
		   Left join dbo.masterRuangan g on a.idRuanganAsal = g.idRuangan
     WHERE a.idTransaksiKonsul = @idTransaksiKonsul;

END