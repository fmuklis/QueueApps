-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterOperatorInsert]
	-- Add the parameters for the stored procedure here
	 @NamaOperator nvarchar(50)
	,@idJenisOperator int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[masterOperator]
			   ([NamaOperator]
			   ,[idJenisOperator])
		 VALUES
			   ( @NamaOperator
				,@idJenisOperator);
	SELECT 'Data Berhasil Disimpan' as respon, 1 as responCode;
END