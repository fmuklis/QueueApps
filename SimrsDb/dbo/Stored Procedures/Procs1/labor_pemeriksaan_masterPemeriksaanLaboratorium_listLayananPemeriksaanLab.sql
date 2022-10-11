-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_listLayananPemeriksaanLab]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idMasterTarifHeader, b.namaTarifHeader AS namaPemeriksaan
	  FROM dbo.masterTarip a
		   INNER JOIN dbo.masterTarifHeader b ON a.idMasterTarifHeader = b.idMasterTarifHeader
	 WHERE a.idMasterPelayanan = 18/*Instalasi Labor*/
  ORDER BY b.namaTarifHeader
END