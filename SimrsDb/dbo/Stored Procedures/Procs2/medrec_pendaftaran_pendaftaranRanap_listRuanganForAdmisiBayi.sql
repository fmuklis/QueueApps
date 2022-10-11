-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listRuanganForAdmisiBayi] 
	-- Add the parameters for the stored procedure here
	@idKelas int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idRuangan, a.namaRuangan
	  FROM dbo.masterRuangan a
		   INNER JOIN dbo.masterRuanganRawatInap b On a.idRuangan = b.idRuangan
				INNER JOIN dbo.masterRuanganTempatTidur ba On b.idRuanganRawatInap = ba.idRuanganRawatInap
				OUTER APPLY(SELECT xa.idPendaftaranPasienDetail  
							  FROM dbo.transaksiPendaftaranPasienDetail xa
								   INNER JOIN dbo.transaksiPendaftaranPasien xb ON xa.idPendaftaranPasien = xb.idPendaftaranPasien AND xb.idStatusPendaftaran < 98/*Belum Pulang*/
							 WHERE xa.idTempatTidur = ba.idTempatTidur AND xa.aktif = 1/*Masih Ditempati*/) bb
	 WHERE b.idKelas = @idKelas AND ba.flagMasihDigunakan = 1/*True*/ AND bb.idPendaftaranPasienDetail IS NULL
  ORDER BY a.namaRuangan
END