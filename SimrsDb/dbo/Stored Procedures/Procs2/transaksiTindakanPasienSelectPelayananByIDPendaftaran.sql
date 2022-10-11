-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiTindakanPasienSelectPelayananByIDPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT d.idMasterPelayanan, d.namaMasterPelayanan
	  FROM dbo.transaksiTindakanPasien a
		   Inner join dbo.masterTarip b On a.idMasterTarif = b.idMasterTarif
		   Inner Join dbo.masterTaripDetail c on a.idMasterTarif = c.idMasterTarip
		   Inner Join dbo.masterPelayanan d On b.idMasterPelayanan = d.idMasterPelayanan
	 WHERE idPendaftaranPasien = @idPendaftaranPasien
  GROUP BY d.idMasterPelayanan, d.namaMasterPelayanan
     UNION ALL
	SELECT 0 As idMasterPelayanan, 'PELAYANAN FARMASI' As namaMasterPelayanan
	  FROM dbo.farmasiResep a
		   Inner Join dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END