-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhpDetail_listItemStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idRuangan  int = (SELECT idRuangan FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH dataSet AS (
	   SELECT xa.idStokOpnameDetail, xa.idJenisStokOpname, xa.idObatDetail, xa.idObatDosis
			 ,xa.kodeBatch, xa.tglExpired, xa.hargaPokok, xa.jumlahAwal, xa.jumlahStokOpname
			 ,xa.keterangan
		 FROM dbo.farmasiStokOpnameDetail xa
	    WHERE xa.idStokOpname = @idStokOpname
	    UNION ALL
	   SELECT NULL AS idStokOpnameDetail, NULL AS idJenisStokOpname, xa.idObatDetail, xa.idObatDosis
			 ,xa.kodeBatch, xa.tglExpired, xa.hargaPokok, xa.stok AS jumlahAwal, 0 AS jumlahStokOpname
			 ,'' AS keterangan
	     FROM dbo.farmasiMasterObatDetail xa
			  LEFT JOIN farmasiStokOpnameDetail xb ON xa.idObatDetail = xb.idObatDetail AND xb.idStokOpname = @idStokOpname
		WHERE xa.tglExpired > CAST(GETDATE() AS date) AND xb.idStokOpnameDetail IS NULL AND xa.idRuangan = @idRuangan
	)
	SELECT a.idStokOpnameDetail, a.idObatDetail, a.idObatDosis, b.namaBarang, a.kodeBatch, a.tglExpired
		  ,a.jumlahAwal AS stokAwal, a.jumlahStokOpname, a.hargaPokok, b.satuanBarang, a.keterangan
		  ,CASE
				WHEN a.idJenisStokOpname = 1/*Tambah Stok*/
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idObatDetail IS NOT NULL AND a.idStokOpnameDetail IS NULL
					 THEN 1
				ELSE 0
			END AS btnKoreksi
		  ,CASE
				WHEN a.idJenisStokOpname = 2/*Koreksi Stok*/
					 THEN 1
				ELSE 0
			END AS btnEditKoreksi
		  ,CASE
				WHEN a.idStokOpnameDetail IS NOT NULL
					 THEN 1
				ELSE 0
			END AS btnDelete
	 FROM dataSet a
		  OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
 ORDER BY btnEdit DESC, btnEditKoreksi DESC, b.namaBarang
END