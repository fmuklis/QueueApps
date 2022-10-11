-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiTindakanLabDelete]
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
	If Not Exists(Select 1 From dbo.transaksiTindakanPasien a
						 Inner Join dbo.transaksiOrderDetail b On a.idOrderDetail = b.idOrderDetail
						 Inner Join dbo.transaksiOrder c On b.idOrder = c.idOrder
				   Where idTindakanPasien = @idTindakanPasien And c.idStatusOrder = 2)
		Begin
			Select 'Tidak Dapat Dihapus, Pemeriksaan Telah Selesai' as respon, 0 as responCode;
		End
	Else
		Begin
			Delete From dbo.transaksiTindakanPasienDetail Where idTindakanPasien = @idTindakanPasien;
			Delete From dbo.transaksiTindakanPasienOperator Where idTindakanPasien = @idTindakanPasien;
			Delete From dbo.transaksiTindakanPasien Where idTindakanPasien = @idTindakanPasien;
			Delete dbo.transaksiOrderDetail Where idOrderDetail = @idOrderDetail;
			Select 'Data Berhasil Dihapus' as respon, 1 as responCode;
		End
END