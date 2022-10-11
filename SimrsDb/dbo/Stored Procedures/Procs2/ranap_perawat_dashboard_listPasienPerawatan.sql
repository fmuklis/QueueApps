-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_dashboard_listPasienPerawatan]	
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT b.noRM, b.namaPasien, b.namaJenisKelamin As jenisKelamin, b.tglLahirPasien, b.umur, a.idPendaftaranPasien
		  ,idStatusPendaftaran, idOrderRawatInap, a.tglDaftarPasien, ea.namaJenisPenjaminInduk, f.idStatusOrderRawatInap
		  ,db.namaRuanganRawatInap +'/ Bed: '+ Convert(nchar(5),da.noTempatTidur) As kamar
	 FROM dbo.transaksiPendaftaranPasien a
		  Outer Apply dbo.getinfo_datapasien(a.idPasien) b
		  Inner Join masterJenisPendaftaran c On a.idJenisPendaftaran=c.idJenisPendaftaran
		  Inner Join dbo.transaksiPendaftaranPasienDetail d On a.idPendaftaranPasien = d.idPendaftaranPasien And d.aktif = 1
				Inner Join dbo.masterRuanganTempatTidur da On d.idTempatTidur = da.idTempatTidur
				Inner Join dbo.masterRuanganRawatInap db On da.idRuanganRawatInap = db.idRuanganRawatInap
		  Left Join dbo.masterJenisPenjaminPembayaranPasien e On a.idJenisPenjaminPembayaranPasien = e.idJenisPenjaminPembayaranPasien
				Left Join dbo.masterJenisPenjaminPembayaranPasienInduk ea On e.idJenisPenjaminInduk = ea.idJenisPenjaminInduk
		  Inner Join dbo.transaksiOrderRawatInap f On a.idPendaftaranPasien = f.idPendaftaranPasien
    WHERE a.idRuangan = @idRuangan And f.idStatusOrderRawatInap = 2 And a.idStatusPendaftaran < 99
 ORDER BY a.tglDaftarPasien Desc;
END