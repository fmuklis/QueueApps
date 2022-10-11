-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spQueue_GetCurrentQueue]
	-- Add the parameters for the stored procedure here
	@counterId TINYINT,
    @serviceTypeId TINYINT,
    @dateOfQueue date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [a].[QueueId], [a].[ServiceTypeId], [a].[CounterId]
          ,[a].[DateOfQueue], [a].[QueueNumber], [a].[QueueStatusId]
	  FROM [queue].[Queue] a
	 WHERE a.QueueStatusId = 3/*Sedang Dilayani*/ AND a.CounterId = @counterId
		   AND a.ServiceTypeId = @serviceTypeId AND a.DateOfQueue = @dateOfQueue;

END