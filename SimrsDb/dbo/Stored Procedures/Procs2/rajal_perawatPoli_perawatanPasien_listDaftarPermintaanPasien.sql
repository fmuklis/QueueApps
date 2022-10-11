-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_perawatanPasien_listDaftarPermintaanPasien]	
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT bb.noRM
		  ,bb.namaPasien
		  ,bb.namaJenisKelamin AS jenisKelamin
		  ,bb.tglLahirPasien
		  ,bb.umur
		  ,a.idPendaftaranPasien
		  ,Convert(Nvarchar(10),a.tglDaftarPasien,108) as jamDaftarPasien
		  ,a.tglDaftarPasien
		  ,idStatusPendaftaran
		  ,idOrderRawatInap
		  ,ea.namaJenisPenjaminInduk
	 FROM [dbo].[transaksiPendaftaranPasien] a
		  Inner join [masterPasien] b on a.[idPasien] = b.[idPasien]
				Inner Join dbo.masterJenisKelamin ba On b.idJenisKelaminPasien = ba.idJenisKelamin
				OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) bb
		  Inner Join masterJenisPendaftaran c On a.idJenisPendaftaran = c.idJenisPendaftaran
		  Inner Join dbo.masterJenisPenjaminPembayaranPasien d On a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
		  Left Join dbo.masterJenisPenjaminPembayaranPasien e On a.idJenisPenjaminPembayaranPasien = e.idJenisPenjaminPembayaranPasien
				Left Join dbo.masterJenisPenjaminPembayaranPasienInduk ea On e.idJenisPenjaminInduk = ea.idJenisPenjaminInduk
    WHERE a.[idStatusPendaftaran] = 1 And a.idRuangan = @idRuangan And idOrderRawatInap = 1
 ORDER BY a.tglDaftarPasien;
END