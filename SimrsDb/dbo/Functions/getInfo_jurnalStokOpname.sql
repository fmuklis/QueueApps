-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_jurnalStokOpname]
(	
	-- Add the parameters for the function here
	@idStokOpnameDetail bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 'Stok Opname '+ COALESCE('BHP '+ bb.alias, ba.namaJenisStok) +' Periode '+ CAST(ca.tahun AS varchar(10)) +' - '+ DATENAME(MONTH, ca.bulan) AS keterangan
		  ,COALESCE('BHP '+ bb.alias, ba.alias) AS ruangan
	  FROM dbo.farmasiStokOpnameDetail a
		   LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
				LEFT JOIN dbo.farmasiMasterObatJenisStok ba ON b.idJenisStok = ba.idJenisStok
				LEFT JOIN dbo.masterRuangan bb ON b.idRuangan = bb.idRuangan
		   LEFT JOIN dbo.farmasiStokOpname c ON a.idStokOpname = c.idStokOpname
				LEFT JOIN dbo.farmasiMasterPeriodeStokOpname ca ON c.idPeriodeStokOpname = ca.idPeriodeStokOpname
	 WHERE a.idStokOpnameDetail = @idStokOpnameDetail
)