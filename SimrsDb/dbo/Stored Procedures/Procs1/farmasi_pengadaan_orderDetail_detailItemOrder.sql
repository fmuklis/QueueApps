-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_detailItemOrder
	-- Add the parameters for the stored procedure here
	@idOrderDetail bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrderDetail, a.idOrder, a.idPabrik, a.idObatDosis, c.namaPabrik, b.namaBarang, b.namaSatuanObat, a.harga, a.jumlah, a.discount, a.ppn
	  FROM dbo.farmasiOrderDetail a
		   Outer Apply dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   Inner Join dbo.farmasiMasterPabrik c On a.idPabrik = c.idPabrik
	 WHERE a.idOrderDetail = @idOrderDetail;
END