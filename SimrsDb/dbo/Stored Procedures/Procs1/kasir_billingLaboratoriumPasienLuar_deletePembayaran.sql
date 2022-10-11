-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[kasir_billingLaboratoriumPasienLuar_deletePembayaran]
	-- Add the parameters for the stored procedure here
	@idPembayaran bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiBillingPembayaran a Inner Join dbo.transaksiBillingHeader b On a.idBilling = b.idBilling Where b.idJenisBayar Is Not Null And a.idPembayaran = @idPembayaran)
		Begin
			Select 'Tidak Dapat Dihapus, Billing Telah Dibayar' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE dbo.transaksiBillingPembayaran
			 WHERE idPembayaran = @idPembayaran;

			Select 'Data Metode Pembayaran Pasien Berhasil Dihapus' As respon, 1 As responCode;
		End
END