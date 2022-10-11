
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create FUNCTION [dbo].[getinfo_listSpesialCMG]
(	
	-- Add the parameters for the function here
	@idBilling bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT b.idTransaksiBillingCMG, ba.idMasterCMGType, ba.kodeCMG, ba.[description], b.kode
		  ,IsNull(b.tarif, 0) As tarif, IsNull(b.tarif, 0) As jumlahTarif
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiBillingCMG b On a.idBilling = b.idBilling
				Inner Join dbo.masterCMG ba On b.idMasterCMG = ba.idMasterCMG
	 WHERE a.idBilling = @idBilling
)