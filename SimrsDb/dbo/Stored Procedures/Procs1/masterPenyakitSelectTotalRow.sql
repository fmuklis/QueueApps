-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPenyakitSelectTotalRow]
	-- Add the parameters for the stored procedure here
	@search nvarchar(100) = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @sql NVARCHAR(MAX)
			,@where NVARCHAR(MAX);
		SET @where = CASE
						When @search is Not Null
							Then 'Where (kodeICD like '''+'%'+@search+'%'''+' Or [namaPenyakit] like '''+'%'+@search+'%'')'
							Else ''
					  END
	SET NOCOUNT ON;
    -- Insert statements for procedure here
    SET @sql = 'SELECT COUNT(*) as jumlahData FROM [dbo].[masterPenyakit] '+@where;
	EXEC(@sql);
--	select @sql
END