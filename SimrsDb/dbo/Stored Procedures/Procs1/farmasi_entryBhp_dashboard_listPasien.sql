-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_entryBhp_dashboard_listPasien]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok tinyint = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idPendaftaranPasien, b.tglDaftarPasien, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur
		  ,c.Alias AS ruanganAsal, bc.NamaOperator AS DPJP, bb.penjamin
		  ,/*CASE
				WHEN cd.idBilling IS NULL
					 THEN 1
				ELSE 0
			END*/1 AS btnDetail
		  ,1 AS btnCetak
 	  FROM dbo.transaksiTindakanPasien a
		   LEFT JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
				LEFT JOIN dbo.masterOperator bc ON b.idDokter = bc.idOperator
		   LEFT JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan
		   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) d
		   INNER JOIN dbo.masterRuangan e ON a.idRuangan = e.idRuangan AND e.idJenisStok = @idJenisStok AND e.idPetugasEntryBhp = 2/*Petugas DEPO/TPO*/
		   LEFT JOIN dbo.transaksiBillingHeader f ON a.idPendaftaranPasien = f.idPendaftaranPasien AND a.idJenisBilling = f.idJenisBilling AND f.idStatusBayar IN(5,10)/*Hutang, Lunas*/
	 WHERE d.BHP = 1/*Ada BHP*/ AND (b.idStatusPendaftaran < 99/*Pulang*/ OR (b.idStatusPendaftaran >= 99/*Pulang*/ AND CAST(a.tglTindakan AS date) BETWEEN @periodeAwal AND @periodeAkhir))
END