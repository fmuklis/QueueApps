-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_dashboard_listSumberAnggaran
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idOrderSumberAnggaran, orderSumberAnggaran
	  FROM dbo.farmasiOrderSumberAnggaran
  ORDER BY orderSumberAnggaran
END