-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Order Pemeriksaan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_dashboard_select_listOrderDiterima]
	-- Add the parameters for the stored procedure here
	@beginDate date,
	@endDate date,
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 500 a.idOrder, a.tglOrder, bb.penjamin, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, c.Alias
		  ,CASE
				WHEN g.idStatusBayar = 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS flagMenungguPembayaran
		  ,CASE
				WHEN a.idStatusOrder = 2
					 THEN 1
				ELSE 0
			END AS btnEnrty
		  ,CASE
				WHEN a.idStatusOrder = 2
					 THEN 1
				ELSE 0
			END AS btnBatalTerima
		  ,CASE
				WHEN a.idStatusOrder = 3/*Selesai Pemeriksaan*/ AND ISNULL(g.idStatusBayar, 1) = 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
		  ,CASE
				WHEN a.idStatusOrder = 3/*Selesai Pemeriksaan*/ AND ISNULL(g.idStatusBayar, 2) <> 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnEntryHasil
		  ,CASE
				WHEN a.idStatusOrder = 4/*Entry Hasil*/ AND ISNULL(g.idStatusBayar, 2) <> 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnEditHasil
		  ,CASE
				WHEN a.idStatusOrder = 5/*Hasil Diotorisasi*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)
					 THEN 1
				ELSE 0
			END AS btnBatalOtorisasi
		  ,CASE
				WHEN d.valid = 1
					 THEN 1
				ELSE 0
			END AS btnCetakHasil
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getinfo_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   LEFT JOIN dbo.masterRuangan c ON a.idRuanganAsal = c.idRuangan
		   OUTER APPLY (SELECT TOP 1 1 AS valid
						  FROM dbo.transaksiOrderDetail xa
							   INNER JOIN dbo.transaksiTindakanPasien xb ON xa.idOrderDetail = xb.idOrderDetail
							   INNER JOIN dbo.transaksiPemeriksaanLaboratorium xc ON xb.idTindakanPasien = xc.idTindakanPasien
						 WHERE xa.idOrder = a.idOrder And xc.valid = 1) d
		   LEFT JOIN dbo.transaksiBillingHeader g ON a.idOrder = g.idOrder
	 WHERE a.idRuanganTujuan = @idRuangan AND (a.idStatusOrder BETWEEN 2/*Request Diterima*/ AND 4/*Entry Hasil*/
		   OR (a.idStatusOrder = 5 AND (a.tanggalModifikasi = CAST(GETDATE() AS date) OR CAST(a.tanggalHasil AS date) BETWEEN @beginDate AND @endDate)))
  ORDER BY a.tglOrder DESC;
END