-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_dataPurchaseOrder]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tglOrder, a.noOrder, b.namaDistroButor, c.orderSumberAnggaran
	  FROM dbo.farmasiOrder a
		   LEFT JOIN dbo.farmasiMasterDistrobutor b ON a.idDistriButor = b.idDistrobutor
		   LEFT JOIN dbo.farmasiOrderSumberAnggaran c ON a.idOrderSumberAnggaran = c.idOrderSumberAnggaran
	 WHERE a.idOrder = @idOrder
END