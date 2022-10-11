CREATE PROCEDURE [dbo].[masterTaripSelect]
	@idMasterPelayanan int = null
AS
BEGIN

	SET NOCOUNT ON;
	IF @idMasterPelayanan IS NOT NULL
		BEGIN
			SELECT namaTarif
			  FROM [dbo].[masterTarip]
			 WHERE idMasterPelayanan = @idMasterPelayanan
		  GROUP BY namaTarif
		  ORDER BY namaTarif
		END
	ELSE
		BEGIN
			SELECT namaTarif
			  FROM [dbo].[masterTarip]
		  GROUP BY namaTarif
		  ORDER BY namaTarif
		END
END