
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_dashboard_listBillingRadiologi] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
			
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, ca.namaRuangan, bb.penjamin, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin
		  ,dbo.calculator_totalTagihanRadiologi(a.idBilling) AS nilaiBayar
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
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   INNER JOIN dbo.transaksiOrder c ON a.idOrder = c.idOrder
				LEFT JOIN dbo.masterRuangan ca ON c.idRuanganTujuan = ca.idRuangan
	 WHERE a.idJenisBilling = 4/*Billing Radiologi*/ AND bb.idJenisPenjaminInduk = 1/*Umum*/ AND (a.idStatusBayar = 1/*Menunggu Pembayaran*/
		   OR (a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)))
END