-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaGolonganPenyakitSearch]
	-- Add the parameters for the stored procedure here
	@search nvarchar(250)
WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @Query nvarchar(MAX)
		   ,@Where nvarchar(MAX) = Case
										When @search Is Not Null
											 Then 'WHERE golonganPenyakit like '''+'%'+@search+'%'''
										Else ''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT idGolonganPenyakit, golonganPenyakit
					FROM dbo.masterDiagnosaGolonganPenyakit '+ @Where +'';
	EXEC(@Query);
	
END