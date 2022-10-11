-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[operasi_tindakan_dashboard_listRequestOperasi]	
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT d.idTransaksiOrderOK, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur, a.idPendaftaranPasien
		  ,idStatusPendaftaran, idOrderRawatInap, d.tglOrder, ea.namaJenisPenjaminInduk, f.namaRuangan
		  ,d.idStatusOrderOK, d.tglJadwal, g.NamaOperator
		  ,CASE WHEN d.tglJadwal IS NULL THEN 2 ELSE 1 END AS ordering
	 FROM dbo.transaksiPendaftaranPasien a
		  OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		  Inner Join masterJenisPendaftaran c On a.idJenisPendaftaran = c.idJenisPendaftaran
		  Inner Join dbo.transaksiOrderOK d On a.idPendaftaranPasien = d.idPendaftaranPasien
		  Left Join dbo.masterJenisPenjaminPembayaranPasien e On a.idJenisPenjaminPembayaranPasien = e.idJenisPenjaminPembayaranPasien
				Left Join dbo.masterJenisPenjaminPembayaranPasienInduk ea On e.idJenisPenjaminInduk = ea.idJenisPenjaminInduk
		  Inner Join dbo.masterRuangan f On a.idRuangan = f.idRuangan
		  LEFT JOIN dbo.masterOperator g ON d.idOperator = g.idOperator
    WHERE a.idStatusPendaftaran < 98 And d.idStatusOrderOK = 1
 ORDER BY ordering, d.tglJadwal, d.tglOrder;
END