-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_listDiagnosaRanap]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling And idStatusKlaim <= 2/*Klaim Dibuat*/)
		BEGIN
			SELECT b.ICD, b.diagnosa, a.primer
			  FROM dbo.transaksiDiagnosaPasien a
				   INNER JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
				   INNER JOIN dbo.transaksiBillingHeader c ON a.idPendaftaranPasien = c.idPendaftaranPasien
			 WHERE c.idBilling = @idBilling
		  ORDER BY a.primer DESC;
		END
	ELSE
		BEGIN
			SELECT b.ICD, b.diagnosa, a.primer
			  FROM dbo.transaksiBillingDiagnosa a
				   INNER JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
			 WHERE a.idBilling = @idBilling
		  ORDER BY a.primer DESC;
		END
END