-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spOutpatientType_GetById]
	-- Add the parameters for the stored procedure here
	@typeId TINYINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [a].[TypeId], [b].TypeName
	  FROM [queue].[ConstServiceType] a
           INNER JOIN [queue].ConstType b ON a.TypeId = b.TypeId
	 WHERE a.ServiceCategoryId = 1/*Pendaftaran Rawat Jalan*/ AND a.TypeId = @typeId;

END