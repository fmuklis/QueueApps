CREATE PROCEDURE [dbo].[masterRuanganSelectByID]
	@idRuangan int
AS
BEGIN

	SET NOCOUNT ON;

	SELECT a.[namaRuangan],a.[idJenisRuangan]
		  ,b.idMasterPelayanan,b.idMasterRuanganPelayanan
		  ,d.namaJenisRuangan
	  FROM [dbo].[masterRuangan] a 
		   INNER JOIN [dbo].[masterRuanganPelayanan] b ON a.idRuangan = b.idRuangan
		   INNER JOIN [dbo].[masterRuanganJenis] d ON a.idJenisRuangan = d.idJenisRuangan
	 WHERE a.idRuangan = @idRuangan;
END