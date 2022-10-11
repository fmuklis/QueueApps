-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_pembayaran_riwayat_listPembayaranRaNap]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, a.tglBayar, bc.alias AS namaRuangan, bb.penjamin, ba.noRM, ba.namaPasien
		  , ba.tglLahirPasien, ba.umur, ba.namaJenisKelamin, dbo.calculator_totalTagihanRawatInap(a.idBilling) AS nilaiBayar
	  FROM dbo.transaksiBillingHeader a
		   LEFT JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
	 WHERE bb.idJenisPenjaminInduk = 1/*UMUM*/ AND a.idJenisBilling = 6/*Billing Tagihan RaNap*/
		   AND a.idStatusBayar = 10/*Selesai Pembayaran*/ AND a.tglBayar BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY a.tglBayar
END