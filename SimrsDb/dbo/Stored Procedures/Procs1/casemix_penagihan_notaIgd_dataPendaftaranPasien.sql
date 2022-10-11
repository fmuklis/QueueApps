-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_notaIgd_dataPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.tglDaftarPasien, b.tglKeluarPasien, ba.noRM, ba.namaPasien, ba.alamatPasien, ba.namaJenisKelamin, ba.tglLahirPasien, ba.umur
		  ,bc.namaRuangan, bb.NamaOperator As DPJP, bd.penjamin, a.cbgKode, a.cbgDescription
		  ,a.subAcuteKode, a.subAcuteDescription, a.chronicKode, a.chronicDescription, a.nilaiBayar
		  ,a.tarifChronic AS jumlahTarifChronic, b.noSEPRawatJalan AS noSEP
		  ,g.kota, a.tarifCbg AS jumlahTarifCbg, a.tarifSubAcute AS jumlahTarifSubAcute 
	  FROM dbo.getinfo_claim(@idBilling) a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getinfo_datapasien(b.idPasien) ba
				LEFT JOIN dbo.masterOperator bb On b.idDokter = bb.idOperator
				LEFT JOIN dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bd
		   OUTER APPLY (SELECT xa.kota
						  FROM dbo.masterRumahSakit xa
						 WHERE xa.idRumahSakit = 1) g;
END