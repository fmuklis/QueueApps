-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Melakukan Pembayaran Yang Bersifat Non Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderUpdateForBayar]
	-- Add the parameters for the stored procedure here
	 @idBilling int
	,@idUserBayar int
	,@idJenisBayar int
	,@keterangan nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling)
		Begin
			UPDATE [dbo].[transaksiBillingHeader]
			   SET [tglBayar] = GETDATE()
				  ,[idUserBayar] = @idUserBayar
				  ,[idJenisBayar] = @idJenisBayar
				  ,[keterangan] = @keterangan
			 WHERE idBilling = @idBilling;
 				Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END