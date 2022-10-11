-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spOutpatient_Create]
	-- Add the parameters for the stored procedure here
	@typeId tinyint,
    @dateOfQueue date,
    @QueueId bigint OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [queue].[Queue]
               ([ServiceTypeId]
               ,[DateOfQueue]
               ,[QueueNumber]
               ,[QueueStatusId])
         SELECT [a].ServiceTypeId
               ,@dateOfQueue
               ,MAX(ISNULL(b.[QueueNumber], 0)) + 1
               ,1/*Belum Dilayani*/
	      FROM [queue].[ConstServiceType] a
               LEFT JOIN [queue].[Queue] b ON a.ServiceTypeId = b.ServiceTypeId AND b.DateOfQueue = @dateOfQueue
	     WHERE a.[ServiceCategoryId] = 1/*Pendaftaran Rawat Jalan*/ AND a.[TypeId] = @typeId
      GROUP BY [a].ServiceTypeId;

    /*GET generated identity*/
    SET @QueueId = SCOPE_IDENTITY();
      
END