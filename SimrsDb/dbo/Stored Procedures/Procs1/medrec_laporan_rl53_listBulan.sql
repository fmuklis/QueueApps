-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl53_listBulan]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT MONTH(tglDaftarPasien) AS bulan
	  FROM dbo.transaksiPendaftaranPasien a
		   INNER JOIN dbo.transaksiDiagnosaPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				INNER JOIN dbo.masterICD ba ON b.idMasterICD = ba.idMasterICD
				INNER JOIN consGolonganSebabPenyakit bb ON ba.idGolonganSebabPenyakit = bb.idGolonganSebabPenyakit AND bb.penyebab = 0
	 WHERE YEAR(a.tglDaftarPasien) = @tahun AND a.idJenisPerawatan = 1/*RaNap*/
  ORDER BY bulan
END