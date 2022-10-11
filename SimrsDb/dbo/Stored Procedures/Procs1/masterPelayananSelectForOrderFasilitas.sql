
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Pelayanan Order Fasilitas
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPelayananSelectForOrderFasilitas]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.idRuangan,a.namaMasterPelayanan
	  FROM dbo.masterPelayanan a
		   Inner Join dbo.masterRuanganPelayanan c On a.idMasterPelayanan = c.idMasterPelayanan
		   Inner Join dbo.masterRuangan d On c.idRuangan = d.idRuangan
	 WHERE d.idJenisRuangan In (4,10)
END