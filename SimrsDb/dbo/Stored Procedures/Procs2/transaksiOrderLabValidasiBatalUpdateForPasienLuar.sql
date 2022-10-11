-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderLabValidasiBatalUpdateForPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiBillingHeader a
			   Where a.idOrder = @idOrder And a.idJenisBayar = 1/*Tunai*/)
		Begin
			Select 'Tidak Dapat Dibatalkan, Pemeriksaan Laboratorium Telah Dibayar' As respon, 0 As responCode; 
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Order Labor*/
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 2/*Dalam Proses*/
			 WHERE idOrder = @idOrder;

			/*DELETE Operator Tindakan*/
			DELETE a
		      FROM dbo.transaksiTindakanPasienOperator a
				   Inner Join dbo.transaksiTindakanPasienDetail b On a.idTindakanPasienDetail = b.idTindakanPasienDetail
						Inner Join dbo.transaksiTindakanPasien ba On b.idTindakanPasien = ba.idTindakanPasien
						Inner Join dbo.transaksiOrderDetail bb On ba.idOrderDetail = bb.idOrderDetail
			 WHERE bb.idOrder = @idOrder;

			/*DELETE Billing Labor*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idOrder = @idOrder;

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