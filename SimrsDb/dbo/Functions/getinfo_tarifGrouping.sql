-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getinfo_tarifGrouping]
(	
	-- Add the parameters for the function here
	@idPendaftaranPasien bigint

)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here

	WITH dataSrc AS (
		/*Get Biaya Tindakan*/
		SELECT REPLACE(b.namaTarifGroup, ' ', '') AS namaTarifGroup, b.jmlBiayaTindakan   
		  FROM dbo.transaksiTindakanPasien a        
			   OUTER APPLY dbo.getInfo_biayaTindakan(a.idTindakanPasien) b  
		 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
		UNION ALL
		/*Get Biaya BMHP*/
		SELECT 'BMHP' AS namaTarifGroup, b.jumlahTarifBHP AS jmlBiayaTindakan
			FROM dbo.transaksiTindakanPasien a
				 OUTER APPLY dbo.getInfo_biayaBHPDetail(a.idTindakanPasien) b
			WHERE a.idPendaftaranPasien = @idPendaftaranPasien
		UNION ALL
		/*Get Biaya Resep*/
		SELECT b.kategoriBarang AS namaTarifGroup, b.jmlHarga AS jmlBiayaTindakan
			FROM dbo.farmasiPenjualanHeader a
				 OUTER APPLY dbo.getInfo_biayaPenjualanBarangFarmasi(a.idPenjualanHeader) b
				 INNER JOIN dbo.farmasiResep c ON a.idResep = c.idResep
			WHERE c.idPendaftaranPasien = @idPendaftaranPasien
		UNION ALL
		/*Get Biaya Kamar*/
		SELECT REPLACE(b.namaTarifGroup, ' ', '') AS namaTarifGroup, a.biayaKamarRawatInap AS jmlBiayaTindakan
		  FROM dbo.getInfo_detailbiayaKamarRawatInap(@idPendaftaranPasien) a
			   LEFT JOIN dbo.masterTarifGroup b ON a.idMasterTarifGroup = b.idMasterTarifGroup)
	SELECT * 
	  FROM dataSrc
	 PIVOT (SUM(jmlBiayaTindakan) 
	   FOR namaTarifGroup 
		   IN([ProsedurNonBedah], [ProsedurBedah], [Konsultasi], [TenagaAhli], [Keperawatan],
			  [Penunjang], [Radiologi], [Laboratorium], [PelayananDarah], [Rehabilitasi],
			  [Kamar/Akomodasi], [RawatIntensif], [Obat], [Kronis], [Kemoterapi],
			  [Alkes], [BMHP], [SewaAlat])) AS dataSet
)