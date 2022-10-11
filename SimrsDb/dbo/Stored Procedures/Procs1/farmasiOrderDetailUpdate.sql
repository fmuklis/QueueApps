-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderDetailUpdate]
	-- Add the parameters for the stored procedure here
	@idOrderDetail int
	,@idObatDosis int
	,@jumlah int
	,@idPabrik int
	,@harga money
	,@discount decimal(18,2)
	,@ppn decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idOrder int = (Select idOrder From dbo.farmasiOrderDetail Where idOrderDetail = @idOrderDetail);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiOrder Where idOrder = @idOrder And idStatusOrder = 1)
		Begin
			UPDATE [dbo].[farmasiOrderDetail]
			   SET [idObatDosis] = @idObatDosis
				  ,[idPabrik] = @idPabrik
				  ,[jumlah] = @jumlah
				  ,[harga] = @harga
				  ,[discount] = @discount
				  ,[ppn] = @ppn
			 WHERE idOrderDetail = @idOrderDetail;
			Select 'Data Barang Purchase Order Berhasil Diupdate' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Tidak Dapat Diupdate, Proses Pemesanan Sudah Selesai' As respon, 0 As responCode;
		End
END