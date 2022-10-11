-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudangCetak_laporan]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStokAsal tinyint = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan)

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.tanggalRetur, c.kodeRetur, ca.namaJenisStok AS stokAsal, cb.namaJenisStok AS tujuanRetur
		  ,cc.namaPetugasFarmasi AS petugasRetur, cd.namaPetugasFarmasi AS penerima, ba.namaBarang
		  ,b.kodeBatch, b.tglExpired, a.jumlahAsal, a.jumlahRetur, a.jumlahAsal - a.jumlahRetur AS sisa, ba.satuanBarang
	  FROM dbo.farmasiReturDetail a
		   LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
		   INNER JOIN dbo.farmasiRetur c ON a.idRetur = c.idRetur
				LEFT JOIN dbo.farmasiMasterObatJenisStok ca ON c.idJenisStokAsal = ca.idJenisStok
				LEFT JOIN dbo.farmasiMasterObatJenisStok cb ON c.idJenisStokTujuan = cb.idJenisStok
				LEFT JOIN dbo.farmasiMasterPetugas cc ON c.idPetugasRetur = cc.idPetugasFarmasi
				LEFT JOIN dbo.farmasiMasterPetugas cd ON c.idPenerima = cd.idPetugasFarmasi
	 WHERE c.idJenisStokAsal = @idJenisStokAsal AND c.idStatusRetur = 10/*Selesai*/
		   AND c.tanggalRetur BETWEEN @periodeAwal AND @periodeAkhir
  ORDER BY c.tanggalRetur, c.kodeRetur, ba.namaBarang
END