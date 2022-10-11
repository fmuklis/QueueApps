-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_cetak_listRincianTindakanByGroupTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint;

	SELECT @idPendaftaranPasien = idPendaftaranPasien
	  FROM dbo.transaksiBillingHeader
	 WHERE idBilling = @idBilling;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH dataSrc AS(
		 /*GET DATA TINDAKAN*/
		 SELECT b.idMasterTarifGroup, a.tglTindakan, c.namaRuangan, b.namaTindakan, d.namaOperator
			   ,b.biayaTindakan, b.jumlahTindakan, b.jmlBiayaTindakan   
		   FROM dbo.transaksiTindakanPasien a        
				OUTER APPLY dbo.getInfo_biayaTindakan(a.idTindakanPasien) b    
				LEFT JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan
				OUTER APPLY dbo.getInfo_operatorTindakan(a.idTindakanPasien) d
		  WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.penagihanTindakan = 1/*Tindakan Ditagih*/
		  UNION ALL
		 /*GET DATA KAMAR INAP*/
		 SELECT a.idMasterTarifGroup, a.tanggalMasuk AS tglTindakan, a.ruanganInap AS namaRuangan, a.kamarInap AS namaTindakan, '' AS namaOperator
			   ,a.tarifKamar AS biayaTindakan, a.lamaInap AS jumlahTindakan, a.biayaKamarRawatInap AS jmlBiayaTindakan
		   FROM dbo.getInfo_detailBiayaKamarRawatInap(@idPendaftaranPasien) a)
	SELECT a.namaTarifGroup, b.tglTindakan, b.namaRuangan, b.namaTindakan, b.namaOperator
		  ,b.biayaTindakan, b.jumlahTindakan, b.jmlBiayaTindakan
	  FROM dbo.masterTarifGroup a
		   INNER JOIN dataSrc b ON a.idMasterTarifGroup = b.idMasterTarifGroup
  ORDER BY a.idMasterTarifGroup, b.tglTindakan
END