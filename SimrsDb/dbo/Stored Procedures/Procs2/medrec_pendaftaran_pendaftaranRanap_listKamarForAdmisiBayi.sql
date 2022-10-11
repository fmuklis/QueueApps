-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listKamarForAdmisiBayi] 
	-- Add the parameters for the stored procedure here
	@idKelas int,
	@idRuangan int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idRuanganRawatInap, a.namaRuanganRawatInap
	  FROM dbo.masterRuanganRawatInap a
		   INNER JOIN dbo.masterRuanganTempatTidur b On a.idRuanganRawatInap = b.idRuanganRawatInap
		   INNER JOIN dbo.masterKelas c ON a.idKelas = c.idKelas
		   OUTER APPLY(SELECT xa.idPendaftaranPasienDetail  
						 FROM dbo.transaksiPendaftaranPasienDetail xa
							  INNER JOIN dbo.transaksiPendaftaranPasien xb ON xa.idPendaftaranPasien = xb.idPendaftaranPasien AND xb.idStatusPendaftaran < 98/*Belum Pulang*/
						WHERE xa.idTempatTidur = b.idTempatTidur AND xa.aktif = 1/*Masih Ditempati*/) d
	 WHERE a.idRuangan = @idRuangan AND b.flagMasihDigunakan = 1/*True*/ AND (a.idKelas = @idKelas OR c.pelayanan = 1) AND d.idPendaftaranPasienDetail IS NULL
  ORDER BY a.namaRuanganRawatInap
END