-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spQueue_GetById]
	-- Add the parameters for the stored procedure here
	@queueId bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [a].[QueueId], [a].[ServiceTypeId], [a].[CounterId]
          ,[a].[DateOfQueue], [a].[QueueNumber], [a].[QueueStatusId]
	  FROM [queue].[Queue] a
	 WHERE a.QueueId = @queueId;

END