-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[kasir_billingLaboratoriumPasienLuar_addPembayaran]
	-- Add the parameters for the stored procedure here
	@idBilling int,
	@idMetodeBayar int,
    @jumlahBayar money,
	@idUserEntry int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiBillingPembayaran 
			   Where idBilling = @idBilling And idMetodeBayar = @idMetodeBayar)
		Begin
			UPDATE dbo.transaksiBillingPembayaran
			   SET jumlahBayar += @jumlahBayar
			 WHERE idBilling = @idBilling And idMetodeBayar = @idMetodeBayar;

			Select 'Data Cara Pembayaran Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			INSERT INTO [dbo].[transaksiBillingPembayaran]
					   ([idBilling]
					   ,[idMetodeBayar]
					   ,[jumlahBayar]
					   ,tanggalEntry
					   ,idUserEntry)
				 VALUES
					   (@idBilling
					   ,@idMetodeBayar
					   ,@jumlahBayar
					   ,GetDate()
					   ,@idUserEntry);

			Select 'Data Cara Pembayaran Berhasil Disimpan' As respon, 1 As responCode;
		End
END