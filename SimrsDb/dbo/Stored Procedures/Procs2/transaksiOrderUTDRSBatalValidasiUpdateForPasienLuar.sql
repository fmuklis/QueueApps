-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderUTDRSBatalValidasiUpdateForPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPasienLuar int = (Select idPasienLuar From dbo.transaksiOrder Where idOrder = @idOrder);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiBillingHeader
			   Where idOrder = @idOrder And idJenisBayar Is Not Null)
		Begin
			Select 'Tidak Dapat Dibatalkan, Pemeriksaan Laboratorium Telah Dibayar' As respon, 0 As responCode; 
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Order Labor*/
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 2/*On Progres*/
			 WHERE idOrder = @idOrder;

			/*DELETE Operator Tindakan*/
			DELETE a
			  FROM dbo.transaksiTindakanPasienOperator a
				   Inner Join dbo.transaksiTindakanPasienDetail b On a.idTindakanPasienDetail = b.idTindakanPasienDetail
				   Inner Join dbo.transaksiTindakanPasien c On b.idTindakanPasien = c.idTindakanPasien
				   Inner Join dbo.transaksiOrderDetail d On c.idOrderDetail = d.idOrderDetail
			 WHERE d.idOrder = @idOrder;

			/*DELETE Hapus Billing Labor*/
			DELETE dbo.transaksiBillingHeader WHERE idOrder = @idOrder;

			/*Transaction Commit*/
			Commit Tran;

			/*Respon*/
			Select 'Validasi Pemeriksaan Laboratorium Berhasil Dibatalkan' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;

			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END