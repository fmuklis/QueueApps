-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_statusFinalRanap]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien a
					 INNER JOIN dbo.transaksiBillingHeader b ON a.idPendaftaranPasien = b.idPendaftaranPasien 
			   WHERE b.idBilling = @idBilling AND a.idStatusPendaftaran < 99)
		BEGIN
			SELECT 'Klaim Tidak Dapat Difinalisasi, Pasien Belum Pulang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling AND idStatusKlaim = 8/*Klaim Sementara*/)
		BEGIN
			SELECT 'Klaim Tidak Dapat Difinalisasi, Klik Tombol Simpan Klaim Dan Lakukan Grouping Ulang' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			/*UPDATE data tarif grouping*/
			UPDATE a
			   SET a.idStatusKlaim = 6/*Klaim Final, Billing Siap Dibayar*/
				  ,a.nilaiBayar = a.cbgTarif + ISNULL(b.specialCMG, 0) + a.subAcuteTarif + a.chronicTarif
			  FROM dbo.transaksiBillingHeader a
				   OUTER APPLY (SELECT SUM(xa.tarif) AS specialCMG FROM dbo.transaksiBillingCMG xa 
								 WHERE xa.idBilling = a.idBilling) b 
			 WHERE a.idBilling = @idBilling;

			Select 'Status Billing Berhasil Diupdate '+ b.statusKlaim As respon, 1 As responCode
			  From dbo.transaksiBillingHeader a
				   Inner Join dbo.masterStatusKlaim b On a.idStatusKlaim = b.idStatusKlaim
			 Where a.idBilling = @idBilling;
		END
END