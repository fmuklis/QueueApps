-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaSelect]
	-- Add the parameters for the stored procedure here
	@page int
	,@size int
	,@search nvarchar(50)
WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @offset nvarchar(50)
			,@newsize nvarchar(50)
			,@Query NVARCHAR(MAX)
			,@where NVARCHAR(MAX) = Case
										 When @search Is Not Null
											  Then 'Where diagnosa like '''+'%'+@search+'%'' Or alias like '''+'%'+@search+'%'''
										 Else ''
									 End
		If(IsNull(@page, 0) = 0)
			Begin
				SELECT @offset = 1, @newsize = @size;
			End
		Else
			Begin
				SELECT @offset = @page + 1, @newsize = @page + @size;				
			End		
				
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT *
				    FROM (SELECT idMasterDiagnosa, a.idGolonganPenyakit, b.golonganPenyakit, diagnosa, alias
							    ,ROW_NUMBER() OVER (ORDER BY diagnosa) As id
								,(Select Count(*)
									From dbo.masterDiagnosa '+ @where +') As jumlahData
								,Case
									  When Exists(Select 1 From dbo.transaksiDiagnosaPasien xa Where a.idMasterDiagnosa = xa.idMasterDiagnosa)
										   Then 0
									  Else 1
								  End As btnHapus
						   FROM dbo.masterDiagnosa a
								Left Join dbo.masterDiagnosaGolonganPenyakit b On a.idGolonganPenyakit = b.idGolonganPenyakit '+ @where +') As dataSet
				   WHERE id Between '+ @offset +' And '+ @newsize;
	EXEC(@Query);
END