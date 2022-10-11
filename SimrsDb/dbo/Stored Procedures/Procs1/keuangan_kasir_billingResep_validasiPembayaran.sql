-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingResep_validasiPembayaran]
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
			If Exists(Select 1 From dbo.transaksiBillingPembayaran Where idBilling = @idBilling And idMetodeBayar = 4/*Piutang Pribadi*/)
				Begin
					UPDATE [dbo].[transaksiBillingHeader]
					   SET [tglBayar] = @tglBayar
						  ,[idUserBayar] = @idUserBayar
						  ,[idJenisBayar] = 3/*Piutang Pribadi*/
						  ,[idStatusBayar] = 5/*Piutang*/
						  ,[keterangan] = @keterangan
					 WHERE [idBilling] = @idBilling;
				End
			Else
				Begin
					UPDATE [dbo].[transaksiBillingHeader]
					   SET [tglBayar] = @tglBayar
						  ,[idUserBayar] = @idUserBayar
						  ,[idJenisBayar] = 1/*Cash/Lunas*/
						  ,[idStatusBayar] = 10/*Selesai Pembayaran*/
						  ,[keterangan] = @keterangan
					 WHERE idBilling = @idBilling;
				End

			/*UPDATE Status Penjualan Apotek*/
			UPDATE a
			   SET a.idStatusPenjualan = 3/*Sudah Dibayar*/
				  ,a.idBilling = b.idBilling
			  FROM dbo.farmasiPenjualanHeader a
				   Inner Join dbo.transaksiBillingHeader b On a.idResep = b.idResep
			 WHERE b.idBilling = @idBilling;

			/*Transaction Commit*/
			Commit Tran;
			Select 'Tagihan Billing Resep Berhasil Dibayar' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch	
END