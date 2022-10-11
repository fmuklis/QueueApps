-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_pengadaan_dashboard_listPengadaan]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, idDistriButor, a.idStatusOrder, a.noOrder, a.tglOrder, b.namaDistroButor, d.orderSumberAnggaran, a.idStatusOrder, c.namaStatusOrder
		  ,CASE
				WHEN a.idStatusOrder = 1/*Proses Entry Order*/
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusOrder = 1/*Proses Entry Order*/
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusOrder = 1/*Proses Entry Order*/
					 THEN 1
				ELSE 0
			END AS btnDelete
		  ,CASE
				WHEN a.idStatusOrder = 2/*Order Valid*/
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
		  ,CASE
				WHEN a.idStatusOrder >= 2/*Order Valid*/
					 THEN 1
				ELSE 0
			END AS btnCetak
	  FROM dbo.farmasiOrder a
		   LEFT JOIN dbo.farmasiMasterDistrobutor b ON a.idDistriButor = b.idDistrobutor
		   LEFT JOIN dbo.farmasiOrderStatus c ON a.idStatusOrder = c.idStatusOrder
		   LEFT JOIN dbo.farmasiOrderSumberAnggaran d ON a.idOrderSumberAnggaran = d.idOrderSumberAnggaran
	 WHERE a.idStatusOrder <= 2 OR (a.idStatusOrder > 2 AND a.tglOrder BETWEEN @periodeAwal AND @periodeAkhir)
  ORDER BY a.idOrder DESC;
END