-- =============================================
-- Author     :	Start -X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Pasien Yang Order Farmasi
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_dashboard_listRequestResepDiterima] 
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 500 a.idResep, a.idPendaftaranPasien,a.tglResep, bd.penjamin, dbo.format_medicalRecord(ba.kodePasien) AS noRM, bc.namaPasien, c.alias
		  ,CASE 
				WHEN a.idStatusResep = 2
					 THEN 1
				ELSE 0
			END AS btnEntry
		  ,CASE 
				WHEN a.idStatusResep = 2
					 THEN 1
				ELSE 0
			END AS btnBatalTerima
		  ,CASE a.idStatusResep
				WHEN 3
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
		  ,CASE a.idStatusResep
				WHEN 3
					 THEN 1
				ELSE 0
			End As btnEticket
		  ,CASE a.idStatusResep
				WHEN 3
					 THEN 1
				ELSE 0
			END AS btnEresep
		  ,CASE
				WHEN ISNULL(e.idStatusBayar, 2) <> 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS flagBayar
	  FROM dbo.farmasiResep a 
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				INNER JOIN dbo.masterPasien ba ON b.idPasien = ba.idPasien
				Inner Join dbo.masterJenisPerawatan bb On b.idJenisPerawatan = bb.idJenisPerawatan
				OUTER APPLY dbo.generate_namaPasien(ba.tglLahirPasien, b.tglDaftarPasien, ba.idJenisKelaminPasien, ba.idStatusPerkawinanPasien, ba.namaLengkapPasien, ba.namaAyahPasien) bc
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bd
		   INNER JOIN dbo.masterRuangan c On a.idRuangan = c.idRuangan And c.idJenisStok = @idJenisStok
		   LEFT JOIN dbo.transaksiBillingHeader e On a.idResep = e.idResep
	 WHERE a.idIMF IS NULL AND (a.idStatusResep = 2/*Sedang Diproses*/ OR (a.idStatusResep = 3/*Telah Selesai*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)))
  ORDER BY a.tanggalModifikasi DESC, a.tglResep DESC
END