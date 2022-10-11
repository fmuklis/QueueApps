-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderDetailInsert]
	-- Add the parameters for the stored procedure here
	@idOrder int
	,@idObatDosis int
	,@jumlah int
	,@harga money
	,@idPabrik int
	,@discount decimal(18,2)
	,@ppn decimal(18,2)

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
			Select 'Data Barang Farmasi Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Sudah Ada Data Yang Sama' As respon, 0 As responCode;
		End
END