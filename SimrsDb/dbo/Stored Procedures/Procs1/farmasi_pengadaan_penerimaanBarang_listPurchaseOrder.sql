-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_listPurchaseOrder]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.idStatusOrder, a.tglOrder, a.noOrder, b.namaDistroButor, c.orderSumberAnggaran
		  ,d.namaStatusOrder AS statusOrder, 1 AS btnEntry
		  ,CASE
				WHEN a.idStatusOrder > 2
					 THEN 1
				ELSE 0
			END AS btnCetak
	  FROM dbo.farmasiOrder a
		   LEFT JOIN dbo.farmasiMasterDistrobutor b ON a.idDistriButor = b.idDistrobutor
		   LEFT JOIN dbo.farmasiOrderSumberAnggaran c ON a.idOrderSumberAnggaran = c.idOrderSumberAnggaran
		   LEFT JOIN dbo.farmasiOrderStatus d ON a.idStatusOrder = d.idStatusOrder
	 WHERE a.idStatusOrder IN(2,3) OR (a.idStatusOrder = 4 AND (a.tglOrder BETWEEN @periodeAwal AND @periodeAkhir)
		   OR a.tanggalModifikasi = CAST(GETDATE() AS date))
  ORDER BY btnEntry DESC, a.tglOrder, a.noOrder;
END