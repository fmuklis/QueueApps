-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_addItemOrder
	-- Add the parameters for the stored procedure here
	@idOrder int,
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
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.farmasiOrderDetail Where idOrder = @idOrder And idObatDosis = @idObatDosis)
		Begin
			INSERT INTO [dbo].[farmasiOrderDetail]
					   ([idOrder]
					   ,[idObatDosis]
					   ,[idPabrik]
					   ,[jumlah]
					   ,harga
					   ,discount
					   ,ppn)
				 VALUES
					   (@idOrder
					   ,@idObatDosis
					   ,@idPabrik
					   ,@jumlah
					   ,@harga
					   ,@discount
					   ,@ppn);

			Select 'Data Item Order Barang Farmasi Berhasil Disimpan' AS respon, 1 AS responCode;
		End
	Else
		Begin
			Select 'Tidak Dapat Disimpan, Item Order Telah Terdaftar' AS respon, 0 AS responCode;
		End
END