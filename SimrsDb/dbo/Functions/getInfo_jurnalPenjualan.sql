-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_jurnalPenjualan]
(	
	-- Add the parameters for the function here
	@idPenjualanDetail bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT CASE
				WHEN a.idResepDetail IS NOT NULL AND a.idTindakanPasien IS NULL AND a.idPemakaianInternal IS NULL
					 THEN 'Penjualan Resep '+ bc.namaJenisRuangan +' No: '+ COALESCE(ba.nomorResep, ba.noResep)
				WHEN a.idResepDetail IS NULL AND a.idTindakanPasien IS NOT NULL AND a.idPemakaianInternal IS NULL
					 THEN 'Pemakaian BHP '+ ca.namaTarif +' '+ cb.alias
				WHEN a.idResepDetail IS NULL AND a.idTindakanPasien IS NULL AND a.idPemakaianInternal IS NOT NULL
					 THEN 'Pemakaian Internal '+ d.pemohon +' Bagian '+ da.namaBagian
			END AS keterangan
		  ,CASE
				WHEN a.idResepDetail IS NOT NULL AND a.idTindakanPasien IS NULL AND a.idPemakaianInternal IS NULL
					 THEN bd.alias
				WHEN a.idResepDetail IS NULL AND a.idTindakanPasien IS NOT NULL AND a.idPemakaianInternal IS NULL
					 THEN cb.alias
				WHEN a.idResepDetail IS NULL AND a.idTindakanPasien IS NULL AND a.idPemakaianInternal IS NOT NULL
					 THEN ea.alias
			END AS ruangan
	  FROM dbo.farmasiPenjualanDetail a
		   LEFT JOIN dbo.farmasiResepDetail b ON a.idResepDetail = b.idResepDetail
				LEFT JOIN dbo.farmasiResep ba ON b.idResep = ba.idResep
				LEFT JOIN dbo.masterRuangan bb ON ba.idRuangan = bb.idRuangan
				LEFT JOIN dbo.masterRuanganJenis bc ON bb.idJenisRuangan = bc.idJenisRuangan
				LEFT JOIN dbo.farmasiMasterObatJenisStok bd ON bb.idJenisStok = bd.idJenisStok
		   LEFT JOIN dbo.transaksiTindakanPasien c ON a.idTindakanPasien = c.idTindakanPasien
				OUTER APPLY dbo.getInfo_tarif(c.idMasterTarif) ca
				LEFT JOIN dbo.masterRuangan cb ON c.idRuangan = cb.idRuangan
		   LEFT JOIN dbo.farmasiPemakaianInternal d ON a.idPemakaianInternal = d.idPemakaianInternal
				LEFT JOIN dbo.farmasiPemakaianInternalBagian da ON d.idBagian = da.idBagian
		   LEFT JOIN dbo.farmasiMasterObatDetail e ON a.idObatDetail = e.idObatDetail
				LEFT JOIN dbo.farmasiMasterObatJenisStok ea ON e.idJenisStok = ea.idJenisStok
	 WHERE a.idPenjualanDetail = @idPenjualanDetail
)