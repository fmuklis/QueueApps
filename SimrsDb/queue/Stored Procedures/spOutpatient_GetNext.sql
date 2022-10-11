-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spOutpatient_GetNext]
	-- Add the parameters for the stored procedure here
    @typeId tinyint,
    @counterId tinyint,
    @dateOfQueue date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    /*Make variable*/
    DECLARE @queueId bigint;

    SELECT @queueId = b.QueueId
      FROM [queue].[ConstServiceType] a 
           INNER JOIN [queue].[Queue] b ON a.ServiceTypeId = b.ServiceTypeId
     WHERE a.TypeId = @typeId AND b.QueueStatusId = 3/*Sedang Dilayani*/
           AND b.DateOfQueue = @dateOfQueue AND b.CounterId = @counterId;
    
    IF @queueId IS NULL
        BEGIN
            WITH nextQueue AS (
                    SELECT [a].[QueueStatusId], [a].[ServiceTypeId], [a].[DateOfQueue]
                          ,MIN([a].[QueueNumber]) AS [QueueNumber]
	                  FROM [queue].[Queue] a
                           INNER JOIN [queue].[ConstServiceType] b ON a.ServiceTypeId = b.ServiceTypeId
	                 WHERE a.QueueStatusId = 1/*Belum Dilayani*/ AND a.DateOfQueue = @dateOfQueue AND b.TypeId = @typeId
                  GROUP BY [a].[QueueStatusId], [a].[ServiceTypeId], [a].[DateOfQueue])

	        SELECT @queueId = b.QueueId
              FROM nextQueue a
                   INNER JOIN [queue].[Queue] b ON a.DateOfQueue = b.DateOfQueue AND a.QueueNumber = b.QueueNumber
                                                   AND a.QueueStatusId = b.QueueStatusId AND a.ServiceTypeId = b.ServiceTypeId;

            UPDATE [queue].[Queue]
               SET [QueueStatusId] = 3/*Sedang Dilayani*/
                  ,[CounterId] = @counterId
             WHERE [QueueId] = @queueId;
        END


        SELECT [a].[QueueId], [ba].TypeName, d.CounterName, [a].[DateOfQueue]
              ,[b].[ServiceTypeCode], [a].[QueueNumber], [c].[StatusName]
          FROM [queue].[Queue] a
               INNER JOIN [queue].[ConstServiceType] b ON a.ServiceTypeId = b.ServiceTypeId
                    INNER JOIN [queue].[ConstType] ba ON b.TypeId = ba.TypeId
               INNER JOIN [queue].[ConstStatus] c ON a.QueueStatusId = c.QueueStatusId
               LEFT JOIN [queue].[ConstCounter] d ON a.CounterId = d.CounterId
         WHERE a.QueueId = @queueId

END