-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhp_laporanOrder]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalOrder, a.nomorOrder, c.namaJenisStok AS tujuanOrder, da.namaBarang, d.sisaStok, d.jumlahOrder, da.namaSatuanObat, b.statusMutasi		
	  FROM dbo.farmasiMutasi a
		   LEFT JOIN dbo.farmasiMasterStatusMutasi b On a.idStatusMutasi = b.idStatusMutasi		  
		   LEFT JOIN dbo.farmasiMasterObatJenisStok c On a.idJenisStokAsal = c.idJenisStok
		   LEFT JOIN dbo.farmasiMutasiOrderItem d ON a.idMutasi = d.idMutasi
				OUTER APPLY dbo.getInfo_barangFarmasi(d.idObatDosis) da
	 WHERE a.idJenisMutasi = 2/*Mutasi BHP*/ AND a.idRuangan = @idRuangan
		   AND (a.idStatusMutasi = 2 OR (a.idStatusMutasi IN(3,4) AND a.tanggalOrder BETWEEN @periodeAwal AND @periodeAkhir))
  ORDER BY a.tanggalOrder, a.nomorOrder, da.namaBarang;
END