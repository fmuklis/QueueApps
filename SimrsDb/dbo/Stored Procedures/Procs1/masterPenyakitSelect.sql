-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPenyakitSelect]
	-- Add the parameters for the stored procedure here
	@page INT,
	@size INT,
	@search nvarchar(100)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @offset INT
		   ,@newsize INT
		   ,@sql NVARCHAR(MAX)
		   ,@where NVARCHAR(MAX)

    SET @where = CASE
						When @search is Not Null
							Then 'Where ICD like '''+'%'+@search+'%'''+' Or diagnosa like '''+'%'+@search+'%'''+' Or [keterangan] like '''+'%'+@search+'%'''
							Else ''
				  END
    IF(@page < = 1)
		BEGIN
			SET @offset = @page;
			SET @newsize = @size;
		END
	ELSE 
		BEGIN
			SET @offset = @page * @size + 1;
			SET @newsize = (@page + 1 ) * @size;
		END
	SET NOCOUNT ON;
    -- Insert statements for procedure here
    SET @sql = 'SELECT idMasterICD As idPenyakit, ICD As kodeICD, diagnosa As namaPenyakit, keterangan
				  FROM (SELECT idMasterICD, ICD, diagnosa, keterangan
							  ,ROW_NUMBER() OVER (ORDER BY idMasterICD) AS Id
							  ,(Select Count(idMasterICD)
								  From dbo.masterICD '+@where+') As jumlahData        
						  FROM dbo.masterICD '+ @where +') dataSet      
				 WHERE [Id] BETWEEN ' + CONVERT(NVARCHAR(12), @offset) + ' AND ' + CONVERT(NVARCHAR(12), (@newsize));
	Exec(@sql);
	---select @sql
END