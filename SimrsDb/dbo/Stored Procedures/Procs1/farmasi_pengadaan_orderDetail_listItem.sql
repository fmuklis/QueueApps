-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_listItem
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrderDetail, a.idOrder, a.idPabrik, a.idObatDosis, c.namaPabrik, b.namaBarang, b.namaSatuanObat, a.harga, a.jumlah, a.discount, a.ppn
	  FROM dbo.farmasiOrderDetail a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   LEFT JOIN dbo.farmasiMasterPabrik c ON a.idPabrik = c.idPabrik
	 WHERE a.idOrder = @idOrder;
END