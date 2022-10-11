-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spServiceType_Get]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [a].[ServiceTypeId], [a].[TypeId], [a].[ServiceCategoryId]
          ,[a].[ServiceTypeName], [a].[ServiceTypeCode]
	  FROM [queue].[ConstServiceType] a;

END