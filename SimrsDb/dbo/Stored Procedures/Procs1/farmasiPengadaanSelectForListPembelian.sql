-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPengadaanSelectForListPembelian]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.idOrder, a.idStatusOrder, noOrder, tglOrder, idDistriButor, b.namaDistroButor, d.noFaktur, d.tglPembelian
	  FROM dbo.farmasiOrder a
		   Inner Join dbo.farmasiMasterDistrobutor b On a.idDistriButor = b.idDistrobutor
		   Inner Join dbo.farmasiOrderDetail c On a.idOrder = c.idOrder
		   Left Join dbo.farmasiPembelian d On a.idOrder = d.idOrder
				Left Join(Select xa.idOrderDetail, Sum(xa.jumlahBeli) As jumlah
							From dbo.farmasiPembelianDetail xa
						Group By xa.idOrderDetail) da On c.idOrderDetail = da.idOrderDetail
	 WHERE a.idStatusOrder In(1,2) Or (a.idStatusOrder = 3 And d.idStatusPembelian = 1)
  ORDER BY noOrder;
END