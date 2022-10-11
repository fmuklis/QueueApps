-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_rincianSementara_dataPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, b.noRM, b.namaPasien, b.umur, b.namaJenisKelamin, c.penjamin, b.alamatPasien
		  ,d.NamaOperator AS DPJP, a.tanggalRawatInap, a.tglKeluarPasien, a.depositRawatInap
		  ,e.totalLamaInap AS lamaInap, f.kamarInap AS ruanganInap
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) c
		   LEFT JOIN dbo.masterOperator d ON a.idDokter = d.idOperator
		   OUTER APPLY dbo.getInfo_biayaKamarRawatInap(a.idPendaftaranPasien) e
		   OUTER APPLY dbo.getInfo_dataRawatInap(a.idPendaftaranPasien) f
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END