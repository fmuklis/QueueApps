-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spStatus_GetById]
	-- Add the parameters for the stored procedure here
	@statusId TINYINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.QueueStatusId, a.StatusName
	  FROM [queue].[ConstStatus] a
	 WHERE a.QueueStatusId = @statusId;

END