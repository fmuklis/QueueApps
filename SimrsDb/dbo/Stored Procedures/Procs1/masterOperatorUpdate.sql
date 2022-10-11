-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterOperatorUpdate]
	-- Add the parameters for the stored procedure here
	 @NamaOperator nvarchar(50)
	,@idJenisOperator int
	,@idOperator int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF Exists (Select 1 From [dbo].[masterOperator] Where idOperator = @idOperator)
		Begin
			UPDATE [dbo].[masterOperator]
			   SET [NamaOperator] = @NamaOperator
				  ,[idJenisOperator] = @idJenisOperator
			 WHERE idOperator = @idOperator;
			 SELECT 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
	ELSE
		Begin
			SELECT 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END