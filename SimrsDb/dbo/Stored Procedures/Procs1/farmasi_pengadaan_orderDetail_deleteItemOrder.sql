-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_deleteItemOrder
	-- Add the parameters for the stored procedure here
	@idOrderDetail bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	DELETE [dbo].[farmasiOrderDetail]
	 WHERE idOrderDetail = @idOrderDetail;

	Select 'Data Item Order Barang Farmasi Berhasil Dihapus' As respon, 1 As responCode;
END