-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingLaboratoriumPasienLuar_discountTotal]
	-- Add the parameters for the stored procedure here
	@idBilling bigint,
	@diskonTunai decimal(18,2),
	@diskonPersen decimal(18,2),
	@nilaiBayar money

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling And idJenisBayar = 1)
		Begin
			Select 'Tidak Dapat Disimpan, Billing Telah Dibayar' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE dbo.transaksiBillingHeader 
			   SET diskonPersen = @diskonPersen
				  ,diskonTunai = @diskonTunai
				  ,nilaiBayar = @nilaiBayar
			 WHERE idBilling = @idBilling;

			Select 'Diskon Pembayaran Berhasil Disimpan' As respon, 1 As responCode;
		End
END