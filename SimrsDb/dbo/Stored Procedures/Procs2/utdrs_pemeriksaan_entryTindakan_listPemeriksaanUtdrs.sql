-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[utdrs_pemeriksaan_entryTindakan_listPemeriksaanUtdrs]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, c.namaTarif AS namaTarifHeader, a.Keterangan, b.idRuangan, c.flagQty, c.BHP, c.satuanTarif 
	  FROM dbo.masterTarip a
		   INNER JOIN dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) c	
	 WHERE a.idKelas = 99 AND b.idRuangan = @idRuangan
  ORDER BY c.namaTarif
END