-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRadiologi_deletePembayaran]
	-- Add the parameters for the stored procedure here
	@idPembayaran bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingPembayaran a
					 INNER JOIN dbo.transaksiBillingHeader b ON a.idBilling = b.idBilling 
			   WHERE b.idStatusBayar <> 1/*Menunggu Pembayaran*/ AND a.idPembayaran = @idPembayaran)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Billing Radiologi Telah Dibayar' As respon, 0 As responCode;
		END
	ELSE
		BEGIN
			DELETE dbo.transaksiBillingPembayaran
			 WHERE idPembayaran = @idPembayaran;

			SELECT 'Data Pembayaran Billing Radiologi Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END