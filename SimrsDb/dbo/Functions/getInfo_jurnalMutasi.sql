-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_jurnalMutasi]
(	
	-- Add the parameters for the function here
	@idLog bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT CASE
				WHEN a.jumlahKeluar > 0
					 THEN 'Mutasi Keluar Ke: '+ COALESCE(('BHP '+ be.alias), bd.alias)
				ELSE 'Mutasi Masuk Dari: '+ bc.alias
			END AS keterangan
		  ,CASE
				WHEN a.jumlahKeluar > 0
					 THEN bc.alias
				ELSE COALESCE(('BHP '+ be.alias), bd.alias)
			END AS ruangan
	  FROM dbo.farmasiJurnalStok a
		   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idMutasiRequestApproved = b.idMutasiRequestApproved
				LEFT JOIN dbo.farmasiMutasiOrderItem ba ON b.idItemOrderMutasi = ba.idItemOrderMutasi
				LEFT JOIN dbo.farmasiMutasi bb ON ba.idMutasi = bb.idMutasi
				LEFT JOIN dbo.farmasiMasterObatJenisStok bc ON bb.idJenisStokAsal = bc.idJenisStok
				LEFT JOIN dbo.farmasiMasterObatJenisStok bd ON bb.idJenisStokTujuan = bd.idJenisStok
				LEFT JOIN dbo.masterRuangan be ON bb.idRuangan = be.idRuangan
	 WHERE a.idLog = @idLog
)