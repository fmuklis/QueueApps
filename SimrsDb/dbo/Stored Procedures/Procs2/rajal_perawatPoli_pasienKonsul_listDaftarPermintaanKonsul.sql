-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_pasienKonsul_listDaftarPermintaanKonsul]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.idTransaksiKonsul ,a.idStatusKonsul ,a.tglOrderKonsul
		   ,b.idPendaftaranPasien ,b.idStatusPendaftaran ,b.idRuangan ,ba.namaRuangan 
		   ,c.kodePasien ,c.noRM ,c.namaPasien ,c.tglLahirPasien ,c.umur ,c.namaJenisKelamin AS jenisKelamin
	  FROM dbo.transaksiKonsul a
		   Inner Join dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
		   		Inner Join dbo.masterRuangan ba On b.idRuangan = ba.idRuangan
		   OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) c
		   Inner Join dbo.masterStatusKonsul d on a.idStatusKonsul = d.idStatusKonsul
	 WHERE a.idStatusKonsul = 1 /*Order Konsul*/ AND a.idRuanganTujuan = @idRuangan
  ORDER BY a.tglOrderKonsul;
END