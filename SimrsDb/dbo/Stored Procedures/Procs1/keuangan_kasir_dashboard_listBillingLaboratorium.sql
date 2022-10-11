-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_dashboard_listBillingLaboratorium] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
			
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 50 a.idBilling, ca.namaRuangan, bb.penjamin, dbo.format_medicalRecord(ba.kodePasien) AS noRM
		  ,bd.namaPasien, be.detailUmur AS umur, bf.namaJenisKelamin
		  ,dbo.calculator_totalTagihanLaboratorium(a.idBilling) AS nilaiBayar
		  ,CASE
				WHEN a.idStatusBayar = 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnBayar
		  ,CASE
				WHEN a.idStatusBayar <> 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnCetak
		  ,CASE
				WHEN a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)
					 THEN 1
				ELSE 0
			END AS btnBatalBayar
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				INNER JOIN dbo.masterPasien ba ON b.idPasien = ba.idPasien
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				OUTER APPLY dbo.generate_namaPasien(ba.tglLahirPasien, b.tglDaftarPasien, ba.idJenisKelaminPasien, ba.idStatusPerkawinanPasien, ba.namaLengkapPasien, ba.namaAyahPasien) bd
				OUTER APPLY dbo.calculator_umur(ba.tglLahirPasien, b.tglDaftarPasien) be
				LEFT JOIN dbo.masterJenisKelamin bf ON ba.idJenisKelaminPasien = bf.idJenisKelamin
		   INNER JOIN dbo.transaksiOrder c ON a.idOrder = c.idOrder
				LEFT JOIN dbo.masterRuangan ca ON c.idRuanganTujuan = ca.idRuangan
	 WHERE a.idJenisBilling = 2/*Billing Laboratorium*/ AND bb.idJenisPenjaminInduk = 1/*UMUM*/ AND (a.idStatusBayar = 1/*Menunggu Pembayaran*/
		   OR (a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)))
  ORDER BY a.idBilling DESC
END