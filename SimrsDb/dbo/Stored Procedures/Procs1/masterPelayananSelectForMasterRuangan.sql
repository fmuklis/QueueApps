-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPelayananSelectForMasterRuangan]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idMasterPelayanan, namaMasterPelayanan
	  FROM dbo.masterPelayanan
	 WHERE idMasterPelayanan Not In(Select a.idMasterPelayanan 
									  From dbo.masterRuanganPelayanan a
										   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan And b.idJenisRuangan <> 2)
  ORDER BY namaMasterPelayanan
END