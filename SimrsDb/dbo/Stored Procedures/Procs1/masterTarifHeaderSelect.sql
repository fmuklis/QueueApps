-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[masterTarifHeaderSelect]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarifHeader, a.namaTarifHeader ,a.keterangan, b.idMasterTarifGroup, a.BHP
	  FROM dbo.masterTarifHeader a
		LEFT JOIN dbo.masterTarifGroup b ON a.idMasterTarifGroup = b.idMasterTarifGroup
  ORDER BY namaTarifHeader
END