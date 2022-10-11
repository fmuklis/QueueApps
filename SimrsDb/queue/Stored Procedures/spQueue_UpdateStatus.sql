-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spQueue_UpdateStatus]
	-- Add the parameters for the stored procedure here
    @queueId BIGINT,
	@queueStatusId TINYINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [queue].[Queue]
       SET [QueueStatusId] = @queueStatusId
	 WHERE [QueueId] = @queueId;
      
END