-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_dataOrder
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT a.idOrder, a.tglOrder, a.noOrder, d.namaDistroButor, b.orderSumberAnggaran, c.namaStatusBayar
	  FROM dbo.farmasiOrder a
		   LEFT JOIN dbo.farmasiOrderSumberAnggaran b On a.idOrderSumberAnggaran = b.idOrderSumberAnggaran
		   LEFT JOIN dbo.farmasiOrderStatusBayar c On a.idStatusBayar = c.idStatusBayar
		   LEFT JOIN dbo.farmasiMasterDistrobutor d On a.idDistriButor = d.idDistrobutor
	 WHERE a.idOrder = @idOrder;
END