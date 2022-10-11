-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_listRuanganAddStockOpnameBhp]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idRuangan, a.namaRuangan
	  FROM dbo.masterRuangan a
		   INNER JOIN dbo.masterRuanganPelayanan b ON a.idRuangan = b.idRuangan
  ORDER BY namaRuangan
END