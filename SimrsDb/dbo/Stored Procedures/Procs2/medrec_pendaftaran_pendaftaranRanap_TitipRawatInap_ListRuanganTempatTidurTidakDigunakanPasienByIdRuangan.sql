-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		takin788
-- Create date: 20/07/2018
-- Description:	untuk menampilkan ruangan yang tidak digunakan pasien
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_TitipRawatInap_ListRuanganTempatTidurTidakDigunakanPasienByIdRuangan]
	-- Add the parameters for the stored procedure here
	@idRuanganRawapInap int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTempatTidur, a.noTempatTidur, a.keteranganTempatTidur, a.kapasitas
	  FROM dbo.masterRuanganTempatTidur a 
	 WHERE a.idRuanganRawatInap = @idRuanganRawapInap AND a.flagMasihDigunakan = 1/*True*/
		   And a.idTempatTidur Not In(Select b.idTempatTidur From dbo.transaksiPendaftaranPasien a
											 Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien And b.aktif = 1
									   Where a.idStatusPendaftaran < 98)
  ORDER BY a.noTempatTidur;
END