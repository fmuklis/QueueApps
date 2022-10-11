-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_editItemOrder
	-- Add the parameters for the stored procedure here
	@idOrderDetail bigint,
	@idObatDosis int,
	@jumlah int,
	@harga money,
	@idPabrik int,
	@discount decimal(18,2),
	@ppn decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idOrder bigint = (Select idOrder From dbo.farmasiOrderDetail Where idOrderDetail = @idOrderDetail);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiOrderDetail Where idOrder = @idOrder And idObatDosis = @idObatDosis And idOrderDetail <> @idOrderDetail)
		Begin
			Select 'Tidak Dapat Diedit, Item Telah Terdaftar' AS respon, 0 AS responCode;
		End
	Else
		Begin
			UPDATE [dbo].[farmasiOrderDetail]
			   SET [idObatDosis] = @idObatDosis
				  ,[idPabrik] = @idPabrik
				  ,[jumlah] = @jumlah
				  ,[harga] = @harga
				  ,[discount] = @discount
				  ,[ppn] = @ppn
			 WHERE idOrderDetail = @idOrderDetail;

			Select 'Data Item Order Barang Farmasi Berhasil Diupdate' AS respon, 1 AS responCode;
		End
END