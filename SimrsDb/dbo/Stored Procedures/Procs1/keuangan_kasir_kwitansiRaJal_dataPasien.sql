-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiRaJal_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT bd.namaRuangan, bb.penjamin, bc.NamaOperator, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin
		  ,a.kodeBayar, b.noReg, a.tglBayar, a.diskonTunai, a.diskonPersen, c.namaLengkap As petugasKasir
		  ,a.keterangan, dbo.calculator_totalTagihanRawatJalan(a.idBilling) AS jumlahBayar, d.kota
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterOperator bc On b.idDokter = bc.idOperator
				LEFT JOIN dbo.masterRuangan bd On b.idRuangan = bd.idRuangan
		   LEFT JOIN dbo.masterUser c On a.idUserBayar = c.idUser
		   OUTER APPLY dbo.getInfo_dataRumahsakit() d
	 WHERE a.idBilling = @idBilling
END