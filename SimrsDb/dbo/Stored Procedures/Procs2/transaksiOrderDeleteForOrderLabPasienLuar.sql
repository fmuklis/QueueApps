-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderDeleteForOrderLabPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPasienLuar bigint = (Select idPasienLuar From dbo.transaksiOrder Where idOrder = @idOrder);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrderDetail a
					 Inner Join dbo.transaksiTindakanPasien b On a.idOrderDetail = b.idOrderDetail
					 Inner Join dbo.transaksiBillingHeader c On a.idOrder = c.idOrder And c.idJenisBayar Is Not Null
			   Where a.idOrder = @idOrder)
		Begin
			Select 'Tidak Dapat Dihapus, Pemeriksaan Laboratorium Telah Dibayar' As respon, 0 As responCode;
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*DELETE Hapus Data Order Pemeriksaan Labor*/
			DELETE dbo.transaksiOrder 
			 WHERE idOrder = @idOrder;

			/*DELETE Hapus Data Pasien Luar*/
			DELETE dbo.masterPasienLuar
			 WHERE idPasienLuar = @idPasienLuar;

			/*Transaction Commit*/
			Commit Tran;
		
			/*Respon*/		   	
			Select 'Data Pemeriksaan Laboratorium Pasien Luar Berhasil Dihapus' As respon, 1 As responCode;								
		End Try
		Begin Catch
			/*Rollback Commit*/
			Rollback Tran;
		
			/*Respon*/		   	
			Select 'Error!: ' As respon, 0 As responCode;
		End Catch
END