-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_laporan_mutasi_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisStokAsal int,
	@idJenisStokTujuan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT unitAsal.namaJenisStok AS unitAsal, unitTujuan.namaJenisStok As unitTujuan, b.tanggalAprove
		  ,cb.namaBarang, ca.kodeBatch, ca.tglExpired, ca.hargaPokok, cb.hargaJual, cb.satuanBarang
		  ,a.sisaStok, a.jumlahOrder, c.jumlahDisetujui
	  FROM dbo.farmasiMutasiOrderItem a
		   INNER JOIN dbo.farmasiMutasi b ON a.idMutasi = b.idMutasi
				INNER JOIN dbo.farmasiMasterObatJenisStok unitAsal ON b.idJenisStokAsal = unitAsal.idJenisStok
				LEFT JOIN dbo.farmasiMasterObatJenisStok unitTujuan ON b.idJenisStokTujuan = unitTujuan.idJenisStok
				LEFT JOIN dbo.masterRuangan ruanganTujuan ON b.idRuangan = ruanganTujuan.idRuangan
		   INNER JOIN dbo.farmasiMutasiRequestApproved c ON a.idItemOrderMutasi = c.idItemOrderMutasi
				INNER JOIN dbo.farmasiMasterObatDetail ca on c.idObatDetail = ca.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(ca.idObatDosis) cb
	 WHERE b.tanggalAprove BETWEEN @periodeAwal AND @periodeAkhir And b.idJenisStokAsal = @idJenisStokAsal
		   AND b.idJenisStokTujuan = @idJenisStokTujuan
  ORDER BY b.tanggalAprove
END