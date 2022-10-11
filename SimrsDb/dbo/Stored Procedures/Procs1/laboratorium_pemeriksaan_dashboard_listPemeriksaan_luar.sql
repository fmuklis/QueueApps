-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_dashboard_listPemeriksaan_luar]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, a.nomorLabor AS kodeOrder, b.nama, b.idJenisKelamin, ba.namaJenisKelamin
		  ,b.tglLahir, b.alamat, b.tlp, b.dokter
		  ,CASE
				WHEN c.idStatusBayar = 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS menungguPembayaran
		  ,CASE
				WHEN a.idStatusOrder <= 2/*Dalam Proses*/
					 THEN 1
				ELSE 0
			END AS btnEntry
		  ,CASE
				WHEN a.idStatusOrder <= 2/*Dalam Proses*/
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusOrder <= 2/*Dalam Proses*/
					 THEN 1
				ELSE 0
			END AS btnHapus
		  ,CASE
				WHEN a.idStatusOrder = 3/*Selesai Pemeriksaan*/ AND ISNULL(c.idStatusBayar, 1) = 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
		  ,CASE
				WHEN a.idStatusOrder = 3/*Selesai Pemeriksaan*/ AND ISNULL(c.idStatusBayar, 2) <> 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnEntryHasil
		  ,CASE
				WHEN a.idStatusOrder = 4/*Entry Hasil*/ AND ISNULL(c.idStatusBayar, 2) <> 1/*Menunggu Pembayaran*/
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
		   INNER JOIN dbo.masterPasienLuar b ON a.idPasienLuar = b.idPasienLuar
				LEFT JOIN dbo.masterJenisKelamin ba ON b.idJenisKelamin = ba.idJenisKelamin
		   LEFT JOIN dbo.transaksiBillingHeader c ON a.idOrder = c.idOrder AND c.idStatusBayar = 1/*Menunggu Pembayaran*/
		   OUTER APPLY (SELECT TOP 1 1 AS valid
						  FROM dbo.transaksiOrderDetail xa
							   INNER JOIN dbo.transaksiTindakanPasien xb ON xa.idOrderDetail = xb.idOrderDetail
							   INNER JOIN dbo.transaksiPemeriksaanLaboratorium xc ON xb.idTindakanPasien = xc.idTindakanPasien
						 WHERE xa.idOrder = a.idOrder AND xc.valid = 1) d
	 WHERE a.idRuanganTujuan = 21/*Laboratorium*/ AND (a.idStatusOrder <= 4/*Entry Hasil*/
		   OR (a.idStatusOrder = 5 AND (a.tanggalModifikasi = CAST(GETDATE() AS date) OR a.tglOrder BETWEEN @periodeAwal AND @periodeAkhir)))
  ORDER BY btnEntry, a.tglOrder;
END