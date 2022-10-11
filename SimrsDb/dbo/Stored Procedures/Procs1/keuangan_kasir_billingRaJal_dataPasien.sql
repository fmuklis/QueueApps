-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaJal_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin, bb.penjamin
		  ,bc.NamaOperator As DPJP, a.kodeBayar, bd.namaRuangan, c.discountTotal, a.diskonTunai, a.diskonPersen
		  ,dbo.calculator_totalTagihanRawatJalan(a.idBilling) AS jumlahBayar 
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.get_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterOperator bc On b.idDokter = bc.idOperator
				LEFT JOIN dbo.masterRuangan bd On b.idRuangan = bd.idRuangan
		   OUTER APPLY (SELECT discountTotal 
						  FROM dbo.sistemKonfigurasiKasir) c
	 WHERE a.idBilling = @idBilling;
END