-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rekapStatusPasienIgd_listBulan]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SELECT DISTINCT MONTH(tglDaftarPasien) AS bulan
	  FROM dbo.transaksiPendaftaranPasien
	 WHERE idJenisPendaftaran = 1/*IGD*/ AND idJenisPerawatan = 2/*RaJal*/
		   AND YEAR(tglDaftarPasien) = @tahun AND idStatusPasien IS NOT NULL
  ORDER BY bulan

END