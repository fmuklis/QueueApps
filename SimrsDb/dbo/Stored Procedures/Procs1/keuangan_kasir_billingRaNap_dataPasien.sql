-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idPendaftaranPasien, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin, bb.idJenisPenjaminInduk, bb.penjamin
		  ,bc.NamaOperator AS DPJP, a.kodeBayar, b.tanggalRawatInap, b.tglKeluarPasien, b.depositRawatInap, bd.totalLamaInap AS lamaInap
		  ,be.kamarInap, c.discountTotal, a.diskonTunai, a.diskonPersen
		  ,dbo.calculator_totalTagihanRawatInap(a.idBilling) AS jumlahBayar 
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.get_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterOperator bc ON b.idDokter = bc.idOperator
				OUTER APPLY dbo.getInfo_biayaKamarRawatInap(b.idPendaftaranPasien) bd
				OUTER APPLY dbo.getInfo_dataRawatInap(b.idPendaftaranPasien) be
		   OUTER APPLY (SELECT discountTotal 
						  FROM dbo.sistemKonfigurasiKasir) c
	 WHERE a.idBilling = @idBilling
END