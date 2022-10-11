-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_dashboard_listBillingIGD]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
			
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, b.idPendaftaranPasien, bb.penjamin, dbo.format_medicalRecord(ba.kodePasien) AS noRM
		  ,bd.namaPasien, be.detailUmur AS umur, bf.namaJenisKelamin, c.nilaiBayar
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
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				INNER JOIN dbo.masterPasien ba ON b.idPasien = ba.idPasien
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				OUTER APPLY dbo.generate_namaPasien(ba.tglLahirPasien, b.tglDaftarPasien, ba.idJenisKelaminPasien, ba.idStatusPerkawinanPasien, ba.namaLengkapPasien, ba.namaAyahPasien) bd
				OUTER APPLY dbo.calculator_umur(ba.tglLahirPasien, b.tglDaftarPasien) be
				LEFT JOIN dbo.masterJenisKelamin bf ON ba.idJenisKelaminPasien = bf.idJenisKelamin
		   OUTER APPLY dbo.getInfo_totalTagihanGawatDarurat(a.idBilling) c
	 WHERE bb.idJenisPenjaminInduk = 1/*UMUM*/ AND a.idJenisBilling = 5 /*Biling IGD*/
		   AND (a.idStatusBayar = 1/*Menunggu Pembayaran*/ OR (a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)))
  ORDER BY a.idBilling DESC
END