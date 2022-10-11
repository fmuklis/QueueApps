-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl315_listData]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH dataSrc AS(
			SELECT a.idPendaftaranPasien, a.idJenisPerawatan, a.idStatusPasien, a.idJenisPenjaminPembayaranPasien
				  ,DATEDIFF(DAY, a.tanggalRawatInap, a.tglKeluarPasien) AS lamaDirawat
			  FROM dbo.transaksiPendaftaranPasien a
			 WHERE YEAR(a.tglDaftarPasien) = @tahun AND a.idStatusPasien IS NOT NULL)
		,dataPembayaran AS(
			SELECT a.idJenisPenjaminPembayaranPasien, b.idJenisBilling, b.idBilling
				  ,CASE
						WHEN b.diskonPersen > 0 OR b.diskonTunai > 0
							 THEN 1
						ELSE 0
				   END AS keringanan
			  FROM dbo.transaksiPendaftaranPasien a
				   INNER JOIN dbo.transaksiBillingHeader b ON a.idPendaftaranPasien = b.idPendaftaranPasien
			 WHERE YEAR(a.tglDaftarPasien) = @tahun AND a.idJenisPerawatan = 2/*RaJal*/ AND b.idStatusBayar <> 1/*Menunggu Pembayaran*/)
	SELECT a.namaJenisPenjaminPembayaranPasien, b.jumlahKeluarPasienRaNap, b.jumlahLamaDirawat
		  ,c.jumlahKeluarPasienRaJal, d.jumlahPembayaranLabor, e.jumlahPembayaranRadiologi, f.jumlahPembayaranLain
	  FROM dbo.masterJenisPenjaminPembayaranPasien a
		   OUTER APPLY(SELECT COUNT(idPendaftaranPasien) AS jumlahKeluarPasienRaNap, ISNULL(SUM(xa.lamaDirawat), 0) AS jumlahLamaDirawat
						 FROM dataSrc xa 
						WHERE xa.idJenisPenjaminPembayaranPasien = a.idJenisPenjaminPembayaranPasien
							  AND xa.idJenisPerawatan = 1/*RaNap*/) b
		   OUTER APPLY(SELECT COUNT(idPendaftaranPasien) AS jumlahKeluarPasienRaJal
						 FROM dataSrc xa 
						WHERE xa.idJenisPenjaminPembayaranPasien = a.idJenisPenjaminPembayaranPasien
							  AND xa.idJenisPerawatan = 2/*RaJal*/) c
		   OUTER APPLY(SELECT COUNT(xa.idBilling) AS jumlahPembayaranLabor
						 FROM dataPembayaran xa 
						WHERE xa.idJenisPenjaminPembayaranPasien = a.idJenisPenjaminPembayaranPasien
							  AND xa.idJenisBilling = 2/*Billing Laboratorium*/) d
		   OUTER APPLY(SELECT COUNT(xa.idBilling) AS jumlahPembayaranRadiologi
						 FROM dataPembayaran xa 
						WHERE xa.idJenisPenjaminPembayaranPasien = a.idJenisPenjaminPembayaranPasien
							  AND xa.idJenisBilling = 4/*Billing Radiologi*/) e
		   OUTER APPLY(SELECT COUNT(xa.idBilling) AS jumlahPembayaranLain
						 FROM dataPembayaran xa 
						WHERE xa.idJenisPenjaminPembayaranPasien = a.idJenisPenjaminPembayaranPasien
							  AND xa.idJenisBilling NOT IN(2,4)/*Billing Laboratorium, Billing Radiologi*/) f
  ORDER BY a.idJenisPenjaminPembayaranPasien
END