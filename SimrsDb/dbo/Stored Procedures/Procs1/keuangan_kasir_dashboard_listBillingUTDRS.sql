-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_dashboard_listBillingUTDRS]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
			
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, a.idPasienLuar, bb.namaRuangan, b.nomorUtdrs, ba.namaPasien, ba.namaJenisKelamin
		  ,ba.tglLahir, ba.umur, ba.tlp, ba.alamatPasien, ba.DPJP, c.nilaiBayar
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
		   INNER JOIN dbo.transaksiOrder b On a.idOrder = b.idOrder And a.idPasienLuar = b.idPasienLuar
				OUTER APPLY dbo.getInfo_dataPasienLuar(a.idPasienLuar, b.tglOrder) ba
				LEFT JOIN dbo.masterRuangan bb On b.idRuanganTujuan = bb.idRuangan
		   OUTER APPLY dbo.getInfo_totalTagihanUtdrs(a.idBilling) c
	 WHERE a.idJenisBilling = 7/*Billing UTDRS*/ AND (a.idStatusBayar = 1/*Menunggu Pembayaran*/
		   OR (a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)))
  ORDER BY btnCetak DESC
END