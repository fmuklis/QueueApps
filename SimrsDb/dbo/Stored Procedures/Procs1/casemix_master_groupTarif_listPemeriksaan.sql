-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_master_groupTarif_listPemeriksaan]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT b.idMasterTarifHeader, b.idMasterTarifGroup, b.namaTarifHeader, ba.namaTarifGroup
	  FROM dbo.masterTarip a
		   INNER JOIN dbo.masterTarifHeader b ON a.idMasterTarifHeader = b.idMasterTarifHeader
				LEFT JOIN dbo.masterTarifGroup ba ON b.idMasterTarifGroup = ba.idMasterTarifGroup
  ORDER BY b.idMasterTarifGroup, b.namaTarifHeader
END