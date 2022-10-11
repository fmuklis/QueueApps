-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl32_listBulan]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT MONTH(tglDaftarPasien) AS bulan
	  FROM dbo.transaksiPendaftaranPasien
	 WHERE YEAR(tglDaftarPasien) = @tahun AND idPelayananIGD IS NOT NULL
		   AND idStatusPasien IS NOT NULL
  ORDER BY bulan
END