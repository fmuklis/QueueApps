-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingLaboratorium_addPembayaran]
	-- Add the parameters for the stored procedure here
	@idBilling bigint,
	@idMetodeBayar int,
    @jumlahBayar money,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingPembayaran 
			   WHERE idBilling = @idBilling AND idMetodeBayar = @idMetodeBayar)
		BEGIN
			UPDATE dbo.transaksiBillingPembayaran
			   SET jumlahBayar += @jumlahBayar
				  ,idUserEntry = @idUserEntry
			 WHERE idBilling = @idBilling AND idMetodeBayar = @idMetodeBayar;

			SELECT 'Data Pembayaran Berhasil Diupdate' AS respon, 1 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[transaksiBillingPembayaran]
					   ([idBilling]
					   ,[idMetodeBayar]
					   ,[jumlahBayar]
					   ,[idUserEntry])
				 VALUES
					   (@idBilling
					   ,@idMetodeBayar
					   ,@jumlahBayar
					   ,@idUserEntry);

			Select 'Data Pembayaran Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END