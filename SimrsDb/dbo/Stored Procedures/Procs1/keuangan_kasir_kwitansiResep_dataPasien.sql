-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiResep_dataPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT b.idPendaftaranPasien, ba.noRM, ba.namaPasien, ba.umur, ba.namaJenisKelamin, bb.penjamin
		  ,ca.NamaOperator AS DPJP, a.kodeBayar, c.noResep, cb.namaRuangan, a.diskonTunai, a.diskonPersen
		  ,dbo.calculator_totalTagihanResep(a.idBilling) AS jumlahBayar, d.namaLengkap AS petugasKasir
		  ,a.tglBayar, e.kota
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.get_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   INNER JOIN dbo.farmasiResep c ON a.idResep = c.idResep
				LEFT JOIN dbo.masterOperator ca ON c.idDokter = ca.idOperator
				LEFT JOIN dbo.masterRuangan cb On c.idRuangan = cb.idRuangan
		   LEFT JOIN dbo.masterUser d On a.idUserBayar = d.idUser
		   OUTER APPLY dbo.getInfo_dataRumahsakit() e
	 WHERE a.idBilling = @idBilling
END