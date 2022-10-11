-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingResep_addDiscountTotal]
	-- Add the parameters for the stored procedure here
	@idBilling bigint,
	@diskonTunai decimal(18,2),
	@diskonPersen decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling AND idStatusBayar <> 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Tagihan Telah Dibayar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE dbo.transaksiBillingHeader 
			   SET diskonPersen = @diskonPersen
				  ,diskonTunai = @diskonTunai
			 WHERE idBilling = @idBilling;

			SELECT 'Diskon Pembayaran Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END