-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiRaNap_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT a.tglBayar, b.noReg, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin, ba.alamatPasien, bb.penjamin
		  ,bc.NamaOperator AS DPJP, a.kodeBayar, b.tglDaftarPasien, b.tanggalRawatInap, b.tglKeluarPasien, b.depositRawatInap
		  , bd.totalLamaInap, be.ruanganInap, be.kamarInap, a.diskonTunai, a.diskonPersen, c.namaLengkap As petugasKasir
		  ,dbo.calculator_totalTagihanRawatInap(a.idBilling) AS jumlahBayar
		  ,a.keterangan, d.kota
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterOperator bc ON b.idDokter = bc.idOperator
				OUTER APPLY dbo.getInfo_biayaKamarRawatInap(b.idPendaftaranPasien) bd
				OUTER APPLY dbo.getInfo_dataRawatInap(b.idPendaftaranPasien) be
		   LEFT JOIN dbo.masterUser c ON a.idUserBayar = c.idUser
		   OUTER APPLY dbo.getInfo_dataRumahsakit() d
	 WHERE a.idBilling = @idBilling
END