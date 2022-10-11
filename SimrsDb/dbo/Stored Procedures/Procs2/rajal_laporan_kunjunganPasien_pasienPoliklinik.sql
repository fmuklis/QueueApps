-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_laporan_kunjunganPasien_pasienPoliklinik]
	-- Add the parameters for the stored procedure here
	 @idRuangan int
	,@periodeAwal date
	,@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT a.idPendaftaranPasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
		  ,a.tglDaftarPasien, d.namaJenisPenjaminPembayaranPasien, f.NamaOperator, g.tglTindakan, h.namaRuangan
		  ,gb.namaTarifHeader, DATEDIFF(MINUTE, a.tglDaftarPasien, g.tglTindakan) AS waktuTunggu
		  ,e.diagnosa AS diagnosaAwal
		  ,IIF(a.idJenisPerawatan = 1/*Rawat Inap*/, 'Rawat Inap', '') AS keterangan
	  FROM dbo.transaksiPendaftaranPasien a 
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   LEFT JOIN dbo.transaksiOrderRawatInap c ON a.idPendaftaranPasien = c.idPendaftaranPasien
		   INNER JOIN dbo.masterJenisPenjaminPembayaranPasien d ON a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
		   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) e
		   INNER JOIN dbo.masterOperator f ON a.idDokter = f.idOperator
		   INNER JOIN dbo.transaksiTindakanPasien g ON a.idPendaftaranPasien = g.idPendaftaranPasien
				INNER JOIN dbo.masterTarip ga ON g.idMasterTarif = ga.idMasterTarif And ga.idKelas = 99
				INNER JOIN dbo.masterTarifHeader gb ON ga.idMasterTarifHeader = gb.idMasterTarifHeader
		   INNER JOIN dbo.masterRuangan h ON (a.idRuangan = h.idRuangan OR c.idRuanganAsal = h.idRuangan) AND h.idJenisRuangan = 3/*Poliklinik Rawat Jalan*/
	 WHERE a.tglDaftarPasien BETWEEN @periodeAwal AND CONCAT(@periodeAkhir, ' 23:59:59') AND (a.idRuangan = @idRuangan OR c.idRuanganAsal = @idRuangan)
  ORDER BY h.namaRuangan, a.tglDaftarPasien
END