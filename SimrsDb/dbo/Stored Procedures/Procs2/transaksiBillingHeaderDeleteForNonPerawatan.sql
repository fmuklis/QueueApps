-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description: Untuk Batal Create Billing
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderDeleteForNonPerawatan]
	-- Add the parameters for the stored procedure here
	 @idBilling int
	,@idJenisBilling int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling And idJenisBilling = @idJenisBilling)
		Begin
			If Exists (Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling And idJenisBilling = @idJenisBilling And tglBayar Is Null And idUserBayar Is Null)
				Begin
					DELETE FROM [dbo].[transaksiBillingHeader]
						  WHERE idBilling = @idBilling And idJenisBilling = @idJenisBilling;

					Select 'Data Berhasil Dihapus' as respon, 1 as responCode;
				End
			Else
				Begin
					Select 'Tidak Dapat Dihapus, Pasien Telah Melakukan Pembayaran' as respon, 0 as responCode;
				End
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END