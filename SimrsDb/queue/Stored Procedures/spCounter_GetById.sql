-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [queue].[spCounter_GetById]
	-- Add the parameters for the stored procedure here
	@counterId TINYINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [a].[CounterId], [a].[CounterName]
	  FROM [queue].[ConstCounter] a
	 WHERE a.[CounterId] = @counterId;

END