-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rekapStatusPasienRaNap_listTahun]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SELECT DISTINCT YEAR(tglDaftarPasien) AS tahun
	  FROM dbo.transaksiPendaftaranPasien
	 WHERE idJenisPerawatan = 1/*RaNap*/ AND idStatusPasien IS NOT NULL
  ORDER BY tahun DESC

END