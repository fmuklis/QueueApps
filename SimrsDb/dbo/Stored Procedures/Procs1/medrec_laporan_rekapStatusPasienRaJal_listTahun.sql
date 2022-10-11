-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rekapStatusPasienRaJal_listTahun]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SELECT DISTINCT YEAR(tglDaftarPasien) AS tahun
	  FROM dbo.transaksiPendaftaranPasien
	 WHERE idJenisPendaftaran = 2/*RaJal*/ AND idJenisPerawatan = 2/*RaJal*/
		   AND idStatusPasien IS NOT NULL
  ORDER BY tahun DESC

END