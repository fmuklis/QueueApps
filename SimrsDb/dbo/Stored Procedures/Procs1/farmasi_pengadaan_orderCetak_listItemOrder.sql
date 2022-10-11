-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_pengadaan_orderCetak_listItemOrder]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.namaPabrik, b.namaBarang, b.namaSatuanObat, a.harga, a.jumlah, a.discount, a.ppn
		  ,(a.harga * a.jumlah) - ((a.harga * a.jumlah) * a.discount / 100) + (((a.harga * a.jumlah) * a.discount / 100) * a.ppn / 100) AS total
	  FROM dbo.farmasiOrderDetail a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   LEFT JOIN dbo.farmasiMasterPabrik c ON a.idPabrik = c.idPabrik
	 WHERE a.idOrder = @idOrder
  ORDER BY c.namaPabrik, b.namaBarang;
END