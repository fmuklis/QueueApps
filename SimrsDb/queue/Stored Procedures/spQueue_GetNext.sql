-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spQueue_GetNext]
	-- Add the parameters for the stored procedure here
    @serviceTypeId TINYINT,
    @dateOfQueue date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    WITH nextQueue AS (
            SELECT [a].[QueueStatusId], [a].[ServiceTypeId], [a].[DateOfQueue]
                  ,MIN([a].[QueueNumber]) AS [QueueNumber]
	          FROM [queue].[Queue] a
	         WHERE a.ServiceTypeId = @serviceTypeId AND a.DateOfQueue = @dateOfQueue
                   AND a.QueueStatusId = 1/*Belum Dilayani*/
          GROUP BY [a].[QueueStatusId], [a].[ServiceTypeId], [a].[DateOfQueue])

    SELECT [b].[QueueId], [b].[ServiceTypeId], [b].[CounterId]
          ,[b].[DateOfQueue], [b].[QueueNumber], [b].[QueueStatusId]
      FROM nextQueue a
           INNER JOIN [queue].[Queue] b ON a.QueueStatusId = b.QueueStatusId AND a.DateOfQueue = b.DateOfQueue
                                           AND a.ServiceTypeId = b.ServiceTypeId AND a.QueueNumber = b.QueueNumber;

END