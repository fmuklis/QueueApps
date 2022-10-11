-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRadiologi_validasiPembayaran]
	-- Add the parameters for the stored procedure here
	@idBilling int,
	@tglBayar date,
	@idUserBayar int,
	@keterangan nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
			
	SET NOCOUNT ON;
    -- Insert statements for procedure here

		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Billing*/
			IF EXISTS(SELECT 1 FROM dbo.transaksiBillingPembayaran a
							 INNER JOIN dbo.masterMetodeBayar b ON a.idMetodeBayar = b.idMetodeBayar
					   WHERE a.idBilling = @idBilling AND b.piutang = 1/*Piutang*/)
				BEGIN
					UPDATE [dbo].[transaksiBillingHeader]
					   SET [tglBayar] = @tglBayar
						  ,[idUserBayar] = @idUserBayar
						  ,[idJenisBayar] = 3/*Piutang Pribadi*/
						  ,[idStatusBayar] = 5/*Piutang*/
						  ,[tanggalModifikasi] = GETDATE()
						  ,[keterangan] = @keterangan
					 WHERE [idBilling] = @idBilling;
				END
			ELSE
				BEGIN
					UPDATE [dbo].[transaksiBillingHeader]
					   SET [tglBayar] = @tglBayar
						  ,[idUserBayar] = @idUserBayar
						  ,[idJenisBayar] = 1/*Cash/Lunas*/
						  ,[idStatusBayar] = 10/*Lunas*/
						  ,[tanggalModifikasi] = GETDATE()
						  ,[keterangan] = @keterangan
					 WHERE idBilling = @idBilling;
				END

			/*Transaction Commit*/
			Commit Tran;
			SELECT 'Tagihan Billing Radiologi Berhasil Dibayar' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch	
END