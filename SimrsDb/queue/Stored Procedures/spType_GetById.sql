-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].spType_GetById
	-- Add the parameters for the stored procedure here
	@typeId TINYINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.TypeId, a.TypeName
	  FROM [queue].ConstType a
	 WHERE a.TypeId = @typeId;

END