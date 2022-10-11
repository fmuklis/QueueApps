-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiTindakanRadiologiDeleteForPasienLuar]
	-- Add the parameters for the stored procedure here
	@idTindakanPasien int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idOrderDetail int = (Select b.idOrderDetail From dbo.transaksiTindakanPasien a
								  Inner Join dbo.transaksiOrderDetail b On a.idOrderDetail = b.idOrderDetail
							Where a.idTindakanPasien = @idTindakanPasien);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiTindakanPasien a
					 Inner Join dbo.transaksiOrderDetail b On a.idOrderDetail = b.idOrderDetail
					 Inner Join dbo.transaksiOrder c On b.idOrder = c.idOrder
			   Where idTindakanPasien = @idTindakanPasien And c.idStatusOrder = 3)
		Begin
			Select 'Tidak Dapat Dihapus, Pemeriksaan Telah Selesai' As respon, 0 As responCode;
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*DELETE Tindakan Pasien*/
			DELETE dbo.transaksiTindakanPasien WHERE idTindakanPasien = @idTindakanPasien;

			/*DELETE Order Detail*/
			DELETE dbo.transaksiOrderDetail WHERE idOrderDetail = @idOrderDetail;

			/*Transaction Commit*/
			Commit Tran;

			/*Respon*/
			Select 'Data Berhasil Dihapus' as respon, 1 as responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;

			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END