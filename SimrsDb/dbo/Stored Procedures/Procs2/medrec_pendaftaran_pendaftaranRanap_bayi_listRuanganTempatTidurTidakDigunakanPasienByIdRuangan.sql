-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		takin788
-- Create date: 20/07/2018
-- Description:	untuk menampilkan ruangan yang tidak digunakan pasien
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_bayi_listRuanganTempatTidurTidakDigunakanPasienByIdRuangan]
	-- Add the parameters for the stored procedure here
	@idRuanganRawatInap int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTempatTidur, a.noTempatTidur
	  FROM dbo.masterRuanganTempatTidur a
		   OUTER APPLY(SELECT xa.idPendaftaranPasienDetail  
						 FROM dbo.transaksiPendaftaranPasienDetail xa
							  INNER JOIN dbo.transaksiPendaftaranPasien xb ON xa.idPendaftaranPasien = xb.idPendaftaranPasien AND xb.idStatusPendaftaran < 98/*Belum Pulang*/
						WHERE xa.idTempatTidur = a.idTempatTidur AND xa.aktif = 1/*Masih Ditempati*/) b
	 WHERE a.idRuanganRawatInap = @idRuanganRawatInap AND b.idPendaftaranPasienDetail IS NULL
  ORDER BY a.noTempatTidur
END