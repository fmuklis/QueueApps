-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterDiagnosaSelectSearch]
	-- Add the parameters for the stored procedure here
	@search nvarchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idMasterDiagnosa As idDiagnosa
		  ,[diagnosa]
		  ,[alias]
	  FROM [dbo].[masterDiagnosa]
	 WHERE diagnosa like '%'+ @search +'%' Or alias like '%'+ @search +'%'
  ORDER BY diagnosa
END