-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION getInfo_dataRumahsakit
(	
	-- Add the parameters for the function here

)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT TOP 1 a.namaRumahSakit, a.namaPendekRumahSakit, a.kodeRS, a.kabupaten, a.kota, a.alamat
	  FROM dbo.masterRumahSakit a
)