-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_pembayaran_riwayat_listPembayaranRaJal]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
			
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, b.idPendaftaranPasien, a.tglBayar, bb.penjamin, ba.noRM, ba.namaPasien
		  ,ba.tglLahirPasien, ba.umur, ba.namaJenisKelamin
		  ,dbo.calculator_totalTagihanRawatJalan(a.idBilling) AS nilaiBayar
		  ,a.idJenisBayar, c.alias AS namaRuangan, a.idRuangan
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.get_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   LEFT JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan
	 WHERE bb.idJenisPenjaminInduk = 1/*UMUM*/ AND a.idJenisBilling = 1 /*Biling Rajal*/
		   AND a.idStatusBayar = 10/*Selesai Pembayaran*/ AND a.tglBayar BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY a.tglBayar
END