-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderSelectByStatusSudahBeli]
	-- Add the parameters for the stored procedure here


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.idOrder, noOrder, tglOrder, c.namaDistroButor, ea.noFaktur, ea.tglPembelian
	  FROM dbo.farmasiOrder a
		   Inner Join dbo.farmasiOrderDetail b on a.idOrder = b.idOrder
		   Inner Join dbo.farmasiMasterDistrobutor c On a.idDistriButor = c.idDistrobutor
		   Inner Join dbo.farmasiOrderStatus d on a.idStatusOrder = d.idStatusOrder
		   Inner Join dbo.farmasiPembelianDetail e on b.idOrderDetail = e.idOrderDetail
				Inner Join dbo.farmasiPembelian ea on e.idPembelianHeader = ea.idPembelianHeader
END