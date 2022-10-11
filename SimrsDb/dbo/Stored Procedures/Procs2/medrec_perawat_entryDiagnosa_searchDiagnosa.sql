-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_perawat_entryDiagnosa_searchDiagnosa]
	-- Add the parameters for the stored procedure here
	@search varchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1000 
		  ICD
		  ,diagnosa
		  ,idMasterICD
	  FROM [dbo].[masterICD]
	 WHERE diagnosa like '%'+ @search +'%' OR ICD like '%'+ @search +'%'
  ORDER BY diagnosa
  
END