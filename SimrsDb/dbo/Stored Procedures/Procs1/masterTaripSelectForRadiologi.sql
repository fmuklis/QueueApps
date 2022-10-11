-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTaripSelectForRadiologi]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, c.namaTarifHeader, a.Keterangan
		   ,b.idRuangan 
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader		
	 WHERE a.idKelas = 99 And b.idRuangan = @idRuangan
  ORDER BY c.namaTarifHeader
END