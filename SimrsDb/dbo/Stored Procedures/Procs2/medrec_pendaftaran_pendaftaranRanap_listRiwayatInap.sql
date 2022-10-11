-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listRiwayatInap]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.idPendaftaranPasienDetail ,a.tanggalMasuk, a.tanggalKeluar, a.lamaInap, a.tarifKamar, a.hargaPokok, 
		   b.kamarInap, c.statusPendaftaranRawatInap, c.idStatusPendaftaranRawatInap,a.ditagih
	  FROM dbo.transaksiPendaftaranPasienDetail a
			OUTER APPLY dbo.getInfo_dataKamarInap(a.idTempatTidur) b
			LEFT JOIN dbo.masterStatusPendaftaranRawatInap c ON a.idStatusPendaftaranRawatInap = c.idStatusPendaftaranRawatInap 

	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.aktif = 'false'
END