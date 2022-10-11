-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_dashboard_listPemeriksaan]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, a.nomorRadiologi AS kodeOrder, b.nama, b.idJenisKelamin, ba.namaJenisKelamin
		  ,b.tglLahir, b.alamat, b.tlp, b.dokter
		  ,CASE
				WHEN c.idBilling IS NOT NULL
					 THEN 1
				ELSE 0
			END AS menungguPembayaran
		  ,CASE
				WHEN a.idStatusOrder <= 2/*Proses Entry Pemeriksaan*/
					 THEN 1
				ELSE 0
			END AS btnEntry
		  ,CASE
				WHEN a.idStatusOrder <= 2/*Proses Entry Pemeriksaan*/
					 THEN 1
				ELSE 0
			END AS btnHapus
		  ,CASE
				WHEN a.idStatusOrder <= 2/*Proses Entry Pemeriksaan*/
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusOrder = 3/*Proses Entry Pemeriksaan*/ AND c.idBilling IS Not NULL /*Belum Bayar*/
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi		 
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.masterPasienLuar b ON a.idPasienLuar = b.idPasienLuar
				LEFT JOIN dbo.masterJenisKelamin ba ON b.idJenisKelamin = ba.idJenisKelamin
		   LEFT JOIN dbo.transaksiBillingHeader c ON a.idOrder = c.idOrder AND c.idStatusBayar = 1/*Menunggu Pembayaran*/
	 WHERE a.idRuanganTujuan = 6/*Radiologi*/ AND a.idStatusOrder <= 2/*Proses Entry Pemeriksaan*/
		   OR (a.idStatusOrder = 3/*Selesai Pemeriksaan*/ AND (a.tanggalModifikasi = CAST(GETDATE() AS date) OR a.tglOrder BETWEEN @periodeAwal AND @periodeAkhir))
  ORDER BY btnEntry, a.tglOrder;
END