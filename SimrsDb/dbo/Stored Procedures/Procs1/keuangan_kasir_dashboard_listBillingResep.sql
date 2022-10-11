-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_dashboard_listBillingResep]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, a.kodeBayar, c.noResep, ba.noRM, ba.namaPasien, ba.namaJenisKelamin, ba.umur, cd.alias AS namaRuangan
		  ,bb.penjamin, cc.statusPenjualan
		  ,d.nilaiBayar
		  ,Case
				When a.idJenisBayar Is Null
					 Then 1
				Else 0
			End As btnBayar
		  ,Case
				When a.idJenisBayar Is Not Null
					 Then 1
				Else 0
			End As btnCetak
		  ,Case
				When a.idJenisBayar Is Not Null And Cast(a.tglBayar As date) = Cast(GetDate() As date)
					 Then 1
				Else 0
			End As btnBatalBayar
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.get_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   INNER JOIN dbo.farmasiResep c On a.idResep = c.idResep
				LEFT JOIN dbo.farmasiPenjualanHeader ca On a.idResep = ca.idResep
				LEFT JOIN dbo.farmasiMasterStatusPenjualan cc On ca.idStatusPenjualan = cc.idStatusPenjualan
				LEFT JOIN dbo.masterRuangan cd On c.idRuangan = cd.idRuangan
		   OUTER APPLY dbo.getinfo_totalTagihanResep(a.idBilling) d
	 WHERE a.idJenisBilling = 3/*Billing Resep*/ AND (a.idStatusBayar = 1/*Menunggu Pembayaran*/
		   OR (a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)))
END