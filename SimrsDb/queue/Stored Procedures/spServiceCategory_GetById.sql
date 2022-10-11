-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spServiceCategory_GetById]
	-- Add the parameters for the stored procedure here
	@serviceCategoryId TINYINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [a].[ServiceCategoryId], [a].[ServiceCategory]
	  FROM [queue].[ConstServiceCategory] a
	 WHERE a.ServiceCategoryId = @serviceCategoryId;

END