-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_notaRajal_dataPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.tglDaftarPasien, b.tglDaftarPasien AS tglInap, b.tglKeluarPasien, ba.noRM, ba.namaPasien, ba.alamatPasien, ba.namaJenisKelamin, ba.tglLahirPasien, ba.umur
		  ,bc.namaRuangan, bb.NamaOperator As DPJP, bd.namaKelas As kelasPenjaminPasien, a.cbgKode, a.cbgDescription
		  ,a.subAcuteKode, a.subAcuteDescription, a.chronicKode, a.chronicDescription, a.nilaiBayar
		  ,g.kota, b.tglKeluarPasien AS tglBayar, c.namaLengkap As petugasKasir, a.tarifCbg AS jumlahTarifCbg, a.tarifSubAcute AS jumlahTarifSubAcute
		  ,a.tarifChronic AS jumlahTarifChronic, b.noSEPRawatJalan AS noSEP
	  FROM dbo.getinfo_claim(@idBilling) a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Outer Apply dbo.getinfo_datapasien(b.idPasien) ba
				Left Join dbo.masterOperator bb On b.idDokter = bb.idOperator
				Left Join dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
				Left Join dbo.masterKelas bd On b.idJenisPenjaminPembayaranPasien = bd.idKelas
		   Left Join dbo.masterUser c On a.idUserBayar = c.idUser
		   Outer Apply (Select xa.kota
						  From dbo.masterRumahSakit xa
						 Where xa.idRumahSakit = 1) g;
END