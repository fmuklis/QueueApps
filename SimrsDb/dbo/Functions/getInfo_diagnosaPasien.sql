-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_diagnosaPasien] 
(	
	-- Add the parameters for the function here
	@idPendaftaranPasien int

)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT COALESCE(
		   (SELECT STRING_AGG(Trim(xb.ICD) +' - '+ Trim(xb.diagnosa), ' + ')
			  FROM dbo.transaksiDiagnosaPasien xa
				   INNER JOIN dbo.masterICD xb ON xa.idMasterICD = xb.idMasterICD
			 WHERE xa.idPendaftaranPasien = @idPendaftaranPasien),
		   (SELECT STRING_AGG(xb.alias, ' + ')
			  FROM dbo.transaksiDiagnosaPasien xa
				   INNER JOIN dbo.masterDiagnosa xb ON xa.idMasterDiagnosa = xb.idMasterDiagnosa
			 WHERE xa.idPendaftaranPasien = @idPendaftaranPasien),
		   (SELECT STRING_AGG(diagnosaAwal, ' + ')
			  FROM dbo.transaksiDiagnosaPasien
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND idMasterDiagnosa IS NULL AND idMasterICD IS NULL)			 
			 ) AS diagnosa
)