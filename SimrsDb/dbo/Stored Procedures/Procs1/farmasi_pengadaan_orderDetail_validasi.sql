-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_validasi
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select Top 1 1 FRom dbo.farmasiOrderDetail Where idOrder = @idOrder)
		Begin
			Select 'Tidak Dapat Divalidasi, Item Order Belum Dientry' AS respon, 0 AS responCode;
		End
	Else
		Begin
			UPDATE [dbo].[farmasiOrder]
			   SET idStatusOrder = 2/*Proses Pemesanan*/
			 WHERE idOrder= @idOrder;

			Select 'Data Order Barang Farmasi Berhasil Divalidasi' AS respon, 1 AS responCode;
		End
END