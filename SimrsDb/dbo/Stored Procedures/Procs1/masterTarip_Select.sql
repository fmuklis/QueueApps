CREATE PROCEDURE [dbo].[masterTarip_Select]
	@idMasterPelayanan int = null
AS
BEGIN

	SET NOCOUNT ON;
	IF @idMasterPelayanan IS NOT NULL
		BEGIN
			SELECT namaTarif,idMasterTarif
			  FROM [dbo].[masterTarip]
			 WHERE idMasterPelayanan = @idMasterPelayanan
		  GROUP BY namaTarif,idMasterTarif
		  ORDER BY namaTarif
		END
	ELSE
		BEGIN
			SELECT namaTarif,idMasterTarif
			  FROM [dbo].[masterTarip]
		  GROUP BY namaTarif,idMasterTarif
		  ORDER BY namaTarif
		END
END