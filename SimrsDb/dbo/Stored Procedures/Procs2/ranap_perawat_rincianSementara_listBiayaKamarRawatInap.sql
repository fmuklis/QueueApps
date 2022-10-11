-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_rincianSementara_listBiayaKamarRawatInap]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT b.ruanganInap, b.kamarInap, a.tanggalMasuk, a.tarifKamar
		  ,COALESCE(a.lamaInap, dbo.calculator_lamaInap(a.tanggalMasuk, COALESCE(a.tanggalKeluar, c.tglKeluarPasien, GETDATE()))) AS lamaInap
		  ,COALESCE(a.tanggalKeluar, c.tglKeluarPasien, GETDATE()) AS tanggalKeluar
		  ,COALESCE(a.lamaInap, dbo.calculator_lamaInap(a.tanggalMasuk, COALESCE(a.tanggalKeluar, c.tglKeluarPasien, GETDATE()))) * CASE WHEN a.ditagih = 1 THEN tarifKamar ELSE 0 END AS biayaKamarRawatInap
	  FROM dbo.transaksiPendaftaranPasienDetail a
		   OUTER APPLY dbo.getInfo_dataKamarInap(a.idTempatTidur) b
		   LEFT JOIN dbo.transaksiPendaftaranPasien c ON a.idPendaftaranPasien = c.idPendaftaranPasien
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.tanggalMasuk
END