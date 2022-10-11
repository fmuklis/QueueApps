-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Data Distributor Farmasi
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_dashboard_detailOrder
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idOrder, a.idDistriButor, a.idOrderSumberAnggaran, idStatusBayar, a.tglOrder
	  FROM dbo.farmasiOrder a
     WHERE idOrder = @idOrder
END