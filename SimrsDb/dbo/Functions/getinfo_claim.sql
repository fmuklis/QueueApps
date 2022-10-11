
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create FUNCTION [dbo].[getinfo_claim]
(	
	-- Add the parameters for the function here
	@idBilling bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idBilling, a.idPendaftaranPasien As idPendaftaranPasien, a.idUserBayar
		  ,a.cbgKode, a.cbgDescription, IsNull(a.cbgTarif, 0) As tarifCbg, a.subAcuteKode, a.subAcuteDescription, IsNull(a.subAcuteTarif, 0) As tarifSubAcute
		  ,a.chronicKode, a.chronicDescription, IsNull(a.chronicTarif, 0) As tarifChronic
		  ,a.nilaiBayar, a.tglBayar
	  FROM dbo.transaksiBillingHeader a
	 WHERE a.idBilling = @idBilling
)