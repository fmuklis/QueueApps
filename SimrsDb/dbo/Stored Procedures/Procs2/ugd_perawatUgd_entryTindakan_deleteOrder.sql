-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Pembatalan Order Fasilitas
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_deleteOrder]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From [dbo].[transaksiOrder] a 
				Where a.idStatusOrder = 1 And idOrder = @idOrder)
		Begin
			DELETE FROM [dbo].[transaksiOrder]  WHERE idOrder = @idOrder;
			Select 'Data Berhasil Dihapus' As respon, 1 As responCode; 
		End
	Else
		Begin
			Select 'Tidak Dapat Dibatalkan, Order Telah ' + xb.namaStatusOrder As respon, 0 As responCode
			  From dbo.transaksiOrder a
				   Inner Join dbo.masterStatusOrder xb On a.idStatusOrder = xb.idStatusOrder										  Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder						
			 Where a.idOrder = @idOrder;
		End
END