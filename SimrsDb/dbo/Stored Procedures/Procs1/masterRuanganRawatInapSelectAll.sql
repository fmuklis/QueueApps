-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganRawatInapSelectAll]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idRuangan]
		  ,[namaRuangan]	
		  ,c.[namaJenisRuangan],a.idjenisRuangan
	  FROM [dbo].[masterRuangan] a
		   Inner Join [dbo].[masterRuanganJenis] c on a.idJenisRuangan = c.idJenisRuangan
	 WHERE a.idJenisRuangan In(2,5)
  ORDER BY [namaRuangan]
END