-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_dashboard_listBillingRaNap]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, bc.alias AS namaRuangan, bb.penjamin, dbo.format_medicalRecord(ba.kodePasien) AS noRM, bd.namaPasien
		  ,be.detailUmur AS umur, bf.namaJenisKelamin, c.nilaiBayar
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
				When a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)
					 Then 1
				Else 0
			End As btnBatalBayar
	  FROM dbo.transaksiBillingHeader a
		   LEFT JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				INNER JOIN dbo.masterPasien ba ON b.idPasien = ba.idPasien
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
				OUTER APPLY dbo.generate_namaPasien(ba.tglLahirPasien, b.tglDaftarPasien, ba.idJenisKelaminPasien, ba.idStatusPerkawinanPasien, ba.namaLengkapPasien, ba.namaAyahPasien) bd
				OUTER APPLY dbo.calculator_umur(ba.tglLahirPasien, b.tglDaftarPasien) be
				LEFT JOIN dbo.masterJenisKelamin bf ON ba.idJenisKelaminPasien = bf.idJenisKelamin
		   OUTER APPLY dbo.getInfo_totalTagihanRawatInap(a.idBilling) c
     WHERE a.idJenisBilling = 6/*Billing Tagihan Rawat Inap*/ AND bb.idJenisPenjaminInduk = 1/*Umum*/
		   AND (a.idStatusBayar = 1/*Menunggu Pembayaran*/ OR(a.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.tanggalModifikasi = CAST(GETDATE() AS date)))
  ORDER BY a.idBilling DESC
END