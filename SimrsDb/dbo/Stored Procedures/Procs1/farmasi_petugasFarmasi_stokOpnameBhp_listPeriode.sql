-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_listPeriode]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idPeriodeStokOpname, b.tahun, b.bulan
	  FROM dbo.farmasiStokOpname a
		   INNER JOIN dbo.farmasiMasterPeriodeStokOpname b ON a.idPeriodeStokOpname = b.idPeriodeStokOpname
	 WHERE a.idRuangan = @idRuangan
  ORDER BY tahun DESC, b.bulan
END