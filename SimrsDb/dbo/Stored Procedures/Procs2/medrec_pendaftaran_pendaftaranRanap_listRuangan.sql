-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listRuangan] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idRuangan, a.Alias, a.namaRuangan, b.namaJenisRuangan, a.idjenisRuangan, c.idMasterPelayanan, ca.namaMasterPelayanan, a.idJenisStok, d.namaJenisStok
	  FROM dbo.masterRuangan a
		   Inner Join dbo.masterRuanganJenis b on a.idJenisRuangan = b.idJenisRuangan
		   Left Join dbo.masterRuanganPelayanan c On a.idRuangan = c.idRuangan
				Left Join dbo.masterPelayanan ca On c.idMasterPelayanan = ca.idMasterPelayanan
		   Left Join dbo.farmasiMasterObatJenisStok d On a.idJenisStok = d.idJenisStok
  ORDER BY namaRuangan;
END