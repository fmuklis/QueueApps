-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_listPemeriksaaanByJenis]
	-- Add the parameters for the stored procedure here
	@idJenisPemeriksaanLaboratorium tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idPemeriksaanLaboratorium, b.idMasterTarifHeader, b.namaTarifHeader AS pemeriksaan, a.nomorUrut
	  FROM dbo.masterLaboratoriumPemeriksaan a
		   LEFT JOIN dbo.masterTarifHeader b ON a.idMasterTarifHeader = b.idMasterTarifHeader
	 WHERE idJenisPemeriksaanLaboratorium = @idJenisPemeriksaanLaboratorium
  ORDER BY nomorUrut
END