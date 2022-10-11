-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Order Pemeriksaan
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_dashboard_listRequestDiterima]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, bb.penjamin, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, c.Alias
		  ,CASE
				WHEN d.idStatusBayar = 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS flagMenungguPembayaran
		  ,Case
				When a.idStatusOrder = 2
					 Then 1
				Else 0
			End As btnEnrty
		  ,Case
				When a.idStatusOrder = 2
					 Then 1
				Else 0
			End As btnBatalTerima
		  ,Case
				When a.idStatusOrder = 3
					 Then 1
				Else 0
			End As btnBatalValidasi
		  ,/*Case
				When a.idStatusOrder = 3 And (d.idPemeriksaanLab Is Null Or e.notValid = 1)
					 Then 1
				Else 0
			End*/0 As btnEntryHasil
		  ,/*Case
				When f.valid = 1
					 Then 1
				Else 0
			End*/0 As btnCetakHasil
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getinfo_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   INNER JOIN dbo.masterRuangan c On a.idRuanganAsal = c.idRuangan
		   LEFT JOIN dbo.transaksiBillingHeader d ON a.idOrder = d.idOrder
	 WHERE a.idRuanganTujuan = @idRuangan And (a.idStatusOrder = 2 Or (a.idStatusOrder = 3 And Cast(a.tanggalModifikasi As date) = Cast(getDate() As date)))
  ORDER BY a.tglOrder;
END