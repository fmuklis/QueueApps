-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[ranap_perawat_entryTindakan_pelayananByIdRuangan]
	-- Add the parameters for the stored procedure here
	@idRuangan int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  a.idMasterPelayanan
			,a.namaMasterPelayanan
	FROM [dbo].[masterPelayanan] a
		 Inner Join dbo.masterTarip b On a.idMasterPelayanan = b.idMasterPelayanan
		 Inner Join dbo.masterRuanganPelayanan c On a.idMasterPelayanan = c.idMasterPelayanan
	WHERE c.idRuangan = @idRuangan
	GROUP BY a.idMasterPelayanan,a.namaMasterPelayanan
	ORDER BY namaMasterPelayanan
END