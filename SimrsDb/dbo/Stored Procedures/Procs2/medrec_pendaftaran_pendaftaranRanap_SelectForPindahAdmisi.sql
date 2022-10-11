
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_SelectForPindahAdmisi] 
	-- Add the parameters for the stored procedure here
	@idKelas int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idRuangan
		  ,a.namaRuangan
	  FROM dbo.masterRuangan a
		   Inner Join dbo.masterRuanganRawatInap b On a.idRuangan = b.idRuangan
				Inner Join dbo.masterRuanganTempatTidur ba On b.idRuanganRawatInap = ba.idRuanganRawatInap
				Inner Join dbo.masterKelas bb On b.idKelas = bb.idKelas
	 WHERE b.idKelas = @idKelas Or bb.pelayanan = 1
		   And ba.idTempatTidur Not In(Select xb.idTempatTidur From dbo.transaksiPendaftaranPasien xa
											  Inner Join dbo.transaksiPendaftaranPasienDetail xb On xa.idPendaftaranPasien = xb.idPendaftaranPasien And xb.aktif = 1
									    WHere xa.idStatusPendaftaran <> 99)
  GROUP BY a.idRuangan, a.namaRuangan
  ORDER BY a.namaRuangan
END