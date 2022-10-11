-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingLaboratorium_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, c.nomorLabor, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin, bb.penjamin
		  ,ca.NamaOperator As DPJP, a.kodeBayar, cb.namaRuangan, d.discountTotal, a.diskonTunai, a.diskonPersen
		  ,dbo.calculator_totalTagihanLaboratorium(a.idBilling) AS jumlahBayar 
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.get_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   INNER JOIN dbo.transaksiOrder c ON a.idOrder = c.idOrder
				LEFT JOIN dbo.masterOperator ca On c.idDokter = ca.idOperator
				LEFT JOIN dbo.masterRuangan cb On c.idRuanganAsal = cb.idRuangan
		   OUTER APPLY (SELECT discountTotal 
						 FROM dbo.sistemKonfigurasiKasir) d
	 WHERE a.idBilling = @idBilling;
END