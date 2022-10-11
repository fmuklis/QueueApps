-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spOutpatient_GetByStatus]
	-- Add the parameters for the stored procedure here
	@queueStatusId tinyint,
    @dateOfQueue date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [b].[QueueId], [c].TypeName, bb.CounterName, [b].[DateOfQueue]
          ,[a].[ServiceTypeCode], [b].[QueueNumber], [ba].[StatusName]
	  FROM [queue].[ConstServiceType] a
           INNER JOIN [queue].[Queue] b ON a.ServiceTypeId = b.ServiceTypeId
                INNER JOIN [queue].[ConstStatus] ba ON b.QueueStatusId = ba.QueueStatusId
                LEFT JOIN [queue].[ConstCounter] bb ON b.CounterId = bb.CounterId
           INNER JOIN [queue].[ConstType] c ON a.TypeId = c.TypeId
	 WHERE a.ServiceCategoryId = 1/*Pendaftaran Rawat Jalan*/ AND b.QueueStatusId = @queueStatusId
           AND b.DateOfQueue = @dateOfQueue;

END