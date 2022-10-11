-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_pengadaan_orderCetak_dataOrder]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT a.tglOrder, a.noOrder, d.namaDistroButor, b.orderSumberAnggaran, e.namaStatusBayar
	  FROM dbo.farmasiOrder a
		   LEFT JOIN dbo.farmasiOrderSumberAnggaran b On a.idOrderSumberAnggaran = b.idOrderSumberAnggaran
		   LEFT JOIN dbo.farmasiOrderStatusBayar c On a.idStatusBayar = c.idStatusBayar
		   LEFT JOIN dbo.farmasiMasterDistrobutor d On a.idDistriButor = d.idDistrobutor
		   LEFT JOIN dbo.farmasiOrderStatusBayar e ON a.idStatusBayar = e.idStatusBayar
	 WHERE a.idOrder = @idOrder;
END