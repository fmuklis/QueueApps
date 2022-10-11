-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Tujuan Permintaan Item Farmasi
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatJenisStokSelectForMutasi]
	-- Add the parameters for the stored procedure here
	@idRuangan int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok int = (Select idJenisStok From masterRuangan Where idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idJenisStok
		  ,namaJenisStok
	  FROM dbo.farmasiMasterObatJenisStok
	 WHERE idJenisStok <> @idJenisStok And idJenisStok Between 1 And 5
  ORDER BY namaJenisStok
END