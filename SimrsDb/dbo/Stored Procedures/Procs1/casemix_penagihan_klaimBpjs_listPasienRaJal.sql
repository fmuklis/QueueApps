-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE   PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_listPasienRaJal]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, c.penjamin, b.tglLahirPasien, CAST(a.tglDaftarPasien AS DATE) AS tglDaftarPasien, 
			CAST(a.tglKeluarPasien AS DATE) AS tglKeluarPasien, b.noRM, b.namaPasien, b.namaJenisKelamin, b.umur, d.NamaOperator AS DPJP, e.namaRuangan, 
			f.idBilling, ISNULL(f.idStatusKlaim, 1) AS idStatusKlaim, ISNULL(a.noSEPRawatJalan, '') AS noSEP
			,CASE WHEN EXISTS(SELECT TOP 1 1
								FROM dbo.transaksiTindakanPasien a        
									LEFT JOIN transaksiBillingHeader b ON a.idPendaftaranPasien = b.idPendaftaranPasien        
									OUTER APPLY dbo.getInfo_biayaTindakan(a.idTindakanPasien) c     
								WHERE b.idBilling = f.idBilling AND c.namaTarifGroup IS NULL)
				THEN
					1
				ELSE 0
			END AS btnGrouping
	  FROM dbo.transaksiPendaftaranPasien a
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) c
		   INNER JOIN dbo.masterOperator d ON a.idDokter = d.idOperator
		   INNER JOIN dbo.masterRuangan e ON a.idRuangan = e.idRuangan
		   LEFT JOIN dbo.transaksiBillingHeader f ON a.idPendaftaranPasien = f.idPendaftaranPasien
	 WHERE a.idStatusPendaftaran >= 99 /*Pulang / Closed*/ AND a.idJenisPendaftaran = 2/*Pendaftaran RaJal*/ AND a.idJenisPerawatan = 2/*Rawat Jalan*/
		   AND c.idJenisPenjaminInduk = 2/*BPJS*/ AND CAST(a.tglKeluarPasien AS date) BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY a.tglKeluarPasien
END