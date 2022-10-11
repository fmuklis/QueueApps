-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION getInfo_dataKamarInap
(	
	-- Add the parameters for the function here
	@idTempatTidur int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT ba.namaRuangan AS ruanganInap, b.namaRuanganRawatInap +' / Bed : '+ CAST(a.noTempatTidur As varchar(10)) AS kamarInap
	  FROM dbo.masterRuanganTempatTidur a
		   LEFT JOIN dbo.masterRuanganRawatInap b ON a.idRuanganRawatInap = b.idRuanganRawatInap
				LEFT JOIN dbo.masterRuangan ba ON b.idRuangan = ba.idRuangan
	 WHERE a.idTempatTidur = @idTempatTidur
)