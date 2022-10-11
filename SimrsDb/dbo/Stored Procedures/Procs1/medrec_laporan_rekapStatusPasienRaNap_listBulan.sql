-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rekapStatusPasienRaNap_listBulan]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SELECT DISTINCT MONTH(tglDaftarPasien) AS bulan
	  FROM dbo.transaksiPendaftaranPasien
	 WHERE idJenisPerawatan = 1/*RaNap*/ AND idStatusPasien IS NOT NULL
		   AND YEAR(tglDaftarPasien) = @tahun
  ORDER BY bulan

END