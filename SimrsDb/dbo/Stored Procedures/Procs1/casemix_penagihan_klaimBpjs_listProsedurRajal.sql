-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_listProsedurRajal]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*If Exists(Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling And idBilingStatus = 1/*Siap Klaim*/)
		Begin
			SELECT bb.ICD, bb.diagnosa, ba.primer
			  FROM dbo.transaksiBillingHeader a
				   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaran = b.idPendaftaranPasien
						Inner Join dbo.transaksiDiagnosaPasien ba On b.idPendaftaranPasien = ba.idPendaftaranPasien
						Inner Join dbo.masterICD bb On ba.idMasterICD = bb.idMasterICD
			 WHERE a.idBilling = @idBilling
		  ORDER BY ba.primer DESC;
		End
	Else
		Begin*/
			SELECT ba.kodeProsedur, ba.prosedur
			  FROM dbo.transaksiBillingHeader a
				   Inner Join dbo.transaksiBillingProsedur b On a.idBilling = b.idBilling
						Inner Join dbo.masterICDProsedur ba On b.idMasterProsedur = ba.idMasterProsedur
			 WHERE a.idBilling = @idBilling;
		/*End*/
END