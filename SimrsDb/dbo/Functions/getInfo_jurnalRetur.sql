-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION getInfo_jurnalRetur
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
				WHEN a.idPenjualanDetail IS NULL AND d.jumlahMasuk > 0
					 THEN 'Retur Masuk Dari: '+ ba.alias
				WHEN a.idPenjualanDetail IS NULL AND d.jumlahKeluar > 0
					 THEN 'Retur Keluar Ke: '+ bb.alias
				ELSE 'Retur Resep '+ cd.namaJenisRuangan +' No: '+ COALESCE(cb.nomorResep, cb.noResep)
			END AS keterangan
		  ,CASE
				WHEN a.idPenjualanDetail IS NULL AND d.jumlahMasuk > 0
					 THEN bb.alias
				WHEN a.idPenjualanDetail IS NULL AND d.jumlahKeluar > 0
					 THEN ba.alias
				ELSE ce.alias
			END AS ruangan
	  FROM dbo.farmasiReturDetail a
		   LEFT JOIN dbo.farmasiRetur b ON a.idRetur = b.idRetur
				LEFT JOIN dbo.farmasiMasterObatJenisStok ba ON b.idJenisStokAsal = ba.idJenisStok
				LEFT JOIN dbo.farmasiMasterObatJenisStok bb ON b.idJenisStokTujuan = bb.idJenisStok
		   LEFT JOIN dbo.farmasiPenjualanDetail c ON a.idPenjualanDetail = c.idPenjualanDetail
				LEFT JOIN dbo.farmasiResepDetail ca ON c.idResepDetail = ca.idResepDetail
				LEFT JOIN dbo.farmasiResep cb ON ca.idResep = cb.idResep
				LEFT JOIN dbo.masterRuangan cc ON cb.idRuangan = cc.idRuangan
				LEFT JOIN dbo.masterRuanganJenis cd ON cc.idJenisRuangan = cd.idJenisRuangan
				LEFT JOIN dbo.farmasiMasterObatJenisStok ce ON cc.idJenisStok = ce.idJenisStok
		   INNER JOIN dbo.farmasiJurnalStok d ON a.idReturDetail = d.idReturDetail
	 WHERE d.idLog = @idLog
)