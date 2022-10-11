-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_addDiscountTotal]
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
	If Exists(Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling And idJenisBayar = 1)
		Begin
			Select 'Tidak Dapat Disimpan, Tagihan Telah Dibayar' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE dbo.transaksiBillingHeader 
			   SET diskonPersen = @diskonPersen
				  ,diskonTunai = @diskonTunai
			 WHERE idBilling = @idBilling;

			Select 'Diskon Pembayaran Berhasil Disimpan' As respon, 1 As responCode;
		End
END