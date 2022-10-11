CREATE PROCEDURE [dbo].[farmasiPengadaanSelectByStatusSudahBeli]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.[idOrder], a.[idStatusOrder], [noOrder], [tglOrder], [idDistriButor], b.namaDistroButor, f.noFaktur, f.keterangan
		  ,a.idStatusOrder, c.namaStatusOrder, f.tglPembelian
	  FROM [dbo].[farmasiOrder] a
		   Inner Join dbo.farmasiMasterDistrobutor b On a.idDistriButor = b.idDistrobutor
		   inner join dbo.farmasiOrderStatus c on a.idStatusOrder = c.idStatusOrder
		   inner join dbo.farmasiOrderDetail d on a.idOrder = d.idOrder
		   inner join dbo.farmasiPembelianDetail e on d.idOrderDetail = e.idOrderDetail
		   inner join dbo.farmasiPembelian f on e.idPembelianHeader = f.idPembelianHeader
	 WHERE a.idStatusOrder = 2
END