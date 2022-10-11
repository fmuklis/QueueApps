-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiLaboratorium_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ca.namaRuangan, bb.penjamin, cb.NamaOperator AS DPJP, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin
		  ,a.kodeBayar, c.nomorLabor, b.noReg, a.tglBayar, a.diskonTunai, a.diskonPersen, d.namaLengkap AS petugasKasir
		  ,dbo.calculator_totalTagihanLaboratorium(a.idBilling) AS nilaiBayar, e.kota
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   INNER JOIN dbo.transaksiOrder c ON a.idOrder = c.idOrder
				LEFT JOIN dbo.masterRuangan ca ON c.idRuanganTujuan = ca.idRuangan
				LEFT JOIN dbo.masterOperator cb On c.idDokter = cb.idOperator
		   LEFT JOIN dbo.masterUser d On a.idUserBayar = d.idUser
		   OUTER APPLY dbo.getInfo_dataRumahsakit() e
	 WHERE a.idBilling = @idBilling
END