-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_statusDikirimRanap]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiPendaftaranPasien a
					INNER JOIN dbo.transaksiBillingHeader b ON a.idPendaftaranPasien = b.idPendaftaranPasien
					WHERE b.idBilling = @idBilling AND a.idStatusPendaftaran <> 99 /*Pulang / Closed*/)
			BEGIN
				SELECT 'Tidak Dapat Dikirim, Status Pasien Belum Pulang' AS respon, 0 AS responCode;
			END
		ELSE 
			BEGIN
				/*UPDATE data tarif grouping*/
				UPDATE dbo.transaksiBillingHeader
					SET idStatusKlaim = 7 /* Klaim Dikirim */
				 WHERE idBilling = @idBilling;

				Select 'Status Billing Berhasil Diupdate '+ b.statusKlaim As respon, 1 As responCode
				  From dbo.transaksiBillingHeader a
					   INNER JOIN dbo.masterStatusKlaim b On a.idStatusKlaim = b.idStatusKlaim
				 Where a.idBilling = @idBilling;
			END
END