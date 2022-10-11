-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_detailBarangFarmasi]
	-- Add the parameters for the stored procedure here
	@idObatDosis int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idObatDosis, a.idSatuanDosis, b.namaObat, a.dosis, d.namaSatuanDosis, c.namaSatuanObat
	  FROM dbo.farmasiMasterObatDosis a
		   LEFT JOIN dbo.farmasiMasterObat b ON a.idObat = b.idObat
		   LEFT JOIN dbo.farmasiMasterSatuanObat c ON a.idSatuanDosis = c.idSatuanObat
		   LEFT JOIN dbo.farmasiMasterObatSatuanDosis d ON a.idSatuanDosis = d.idSatuanDosis
	 WHERE a.idObatDosis = @idObatDosis
END