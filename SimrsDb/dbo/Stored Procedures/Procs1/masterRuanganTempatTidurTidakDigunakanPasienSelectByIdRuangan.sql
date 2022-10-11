-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		takin788
-- Create date: 20/07/2018
-- Description:	untuk menampilkan ruangan yang tidak digunakan pasien
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganTempatTidurTidakDigunakanPasienSelectByIdRuangan]
	-- Add the parameters for the stored procedure here
	@idRuanganRawapInap int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.* 
	  FROM dbo.masterRuanganTempatTidur a 
	 WHERE a.idRuanganRawatInap = @idRuanganRawapInap
		   And a.idTempatTidur Not In(Select b.idTempatTidur From dbo.transaksiPendaftaranPasien a
											 Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien And b.aktif = 1
									   Where a.idStatusPendaftaran < 98);
END