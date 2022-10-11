-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_cetak_rekapTindakanKelompokTarif]   
-- Add the parameters for the stored procedure here   
	@idBilling bigint    
AS  
BEGIN   
	-- SET NOCOUNT ON    
	-- Insert statements for procedure here
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling)
	SET NOCOUNT ON;
	
	WITH dataSrc AS (
		/*GET DATA TINDAKAN*/
		SELECT b.idMasterTarifGroup, b.jmlBiayaTindakan   
		  FROM dbo.transaksiTindakanPasien a
			   OUTER APPLY dbo.getInfo_biayaTindakan(a.idTindakanPasien) b
		 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.penagihanTindakan = 1/*Ditagih*/
		 UNION ALL
		/*GET DATA BHP*/
		SELECT 18 AS idMasterTarifGroup, b.jumlahTarifBHP AS jmlBiayaTindakan
		  FROM dbo.transaksiTindakanPasien a
			   OUTER APPLY dbo.getInfo_biayaBHP(a.idTindakanPasien) b
		 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
		 UNION ALL
		/*GET DATA RESEP*/
		SELECT b.idMasterTarifGroup, b.jmlHarga AS jmlBiayaTindakan
		  FROM dbo.farmasiPenjualanHeader a
			   OUTER APPLY dbo.getInfo_biayaPenjualanBarangFarmasi(a.idPenjualanHeader) b
			   INNER JOIN dbo.farmasiResep c ON a.idResep = c.idResep
	 	 WHERE c.idPendaftaranPasien = @idPendaftaranPasien
		 UNION ALL
		/*GET DATA KAMAR INAP*/
		SELECT a.idMasterTarifGroup, a.tarifKamar * a.lamaInap AS jmlBiayaTindakan
		  FROM dbo.getInfo_detailBiayaKamarRawatInap(@idPendaftaranPasien) a)
	SELECT a.namaTarifGroup, SUM(jmlBiayaTindakan) AS jmlBiaya
	  FROM dbo.masterTarifGroup a
		   LEFT JOIN dataSrc b ON a.idMasterTarifGroup = b.idMasterTarifGroup
  GROUP BY a.namaTarifGroup, a.idMasterTarifGroup
  ORDER BY a.idMasterTarifGroup
END