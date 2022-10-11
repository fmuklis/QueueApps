-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhpCetak_listItemStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT b.jenisStokOpname, ba.namaBarang, b.kodeBatch, b.tglExpired, b.hargaPokok, b.jumlahAwal, b.jumlahStokOpname
				,ba.satuanBarang, b.keterangan
		  FROM dbo.farmasiStokOpname a
			   OUTER APPLY (SELECT xa.idStokOpnameDetail, xa.idJenisStokOpname, xb.jenisStokOpname, xa.idObatDetail, xa.idObatDosis
								  ,xa.kodeBatch, xa.tglExpired, xa.hargaPokok, xa.jumlahAwal, xa.jumlahStokOpname
								  ,xa.keterangan
							  FROM dbo.farmasiStokOpnameDetail xa
								LEFT JOIN farmasiMasterJenisStokOpname xb ON xa.idJenisStokOpname = xb.idJenisStokOpname
							 WHERE xa.idStokOpname = a.idStokOpname
							 UNION ALL
							SELECT NULL AS idStokOpnameDetail, NULL AS idJenisStokOpname, '' AS jenisStokOpname, xa.idObatDetail, xa.idObatDosis
								  ,xa.kodeBatch, xa.tglExpired, xa.hargaPokok, xa.stok AS jumlahAwal, 0 AS jumlahStokOpname
								  ,'' AS keterangan
							  FROM dbo.farmasiMasterObatDetail xa
								   LEFT JOIN farmasiStokOpnameDetail xb ON xa.idObatDetail = xa.idObatDetail
							 WHERE xa.tglExpired > GETDATE() AND xb.idStokOpnameDetail IS NULL AND xa.idRuangan = a.idRuangan) b
					OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
		 WHERE a.idStokOpname = @idStokOpname
	  ORDER BY b.jenisStokOpname DESC, ba.namaBarang
END