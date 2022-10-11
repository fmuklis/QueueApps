
-- =============================================
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Pembatalan Ranap Pasien Rajal
-- =============================================
CREATE PROCEDURE [dbo].[ugd_perawatUgd_dashboard_batalOrderInap] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiOrderRawatInap WHERE idPendaftaranPasien = @idPendaftaranPasien
					 AND idStatusOrderRawatInap NOT IN(1,4))
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, '+ b.caption As respon, 0 As responCode
			  FROM dbo.transaksiOrderRawatInap a
				   LEFT JOIN dbo.masterStatusOrderRawatInap b On a.idStatusOrderRawatInap = b.idStatusOrderRawatInap
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
		END
	ELSE
		BEGIN
			DELETE [dbo].[transaksiOrderRawatInap]
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 3/*Dalam Perawatan IGD*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			SELECT 'Request Rawat Inap Dibatalkan' AS respon, 1 AS responCode;
		END
END