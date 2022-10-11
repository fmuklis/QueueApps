-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_stokBarangFarmasi_listBulan]
	-- Add the parameters for the stored procedure here
	@year int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT MONTH(a.tanggalEntry) AS [month]
	  FROM dbo.farmasiJurnalStok a
	 WHERE YEAR(a.tanggalEntry) = @year
  ORDER BY [month]
END