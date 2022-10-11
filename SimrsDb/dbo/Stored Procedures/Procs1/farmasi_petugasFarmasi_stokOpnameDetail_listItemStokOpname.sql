-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameDetail_listItemStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint,
	@start nchar(10),
	@length nchar(10),
	@search varchar(50)

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @currenctDate date = GETDATE()
		   ,@query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@idSO bigint, @nowDate date, @like varchar(50)'
		   ,@filter nvarchar(max) = CASE
										 WHEN LEN(@search) >= 3
											  THEN 'AND ba.namaBarang LIKE ''%''+ @like +''%'''
										 ELSE ''
									END 
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = '
		SELECT b.idStokOpnameDetail, b.idObatDetail, ba.namaBarang, b.kodeBatch
			  ,b.tglExpired, b.jumlahAwal AS stokAwal, b.keterangan, b.hargaPokok, b.idObatDosis
			  ,b.jumlahStokOpname, ba.satuanBarang, jumlahData = COUNT(*) OVER()
			  ,CASE
					WHEN b.idJenisStokOpname = 1/*Tambah Stok*/
						 THEN 1
					ELSE 0
				END AS btnEdit
			  ,CASE
					WHEN b.idObatDetail IS NOT NULL AND b.idStokOpnameDetail IS NULL
						 THEN 1
					ELSE 0
				END AS btnKoreksi
			  ,CASE
					WHEN b.idJenisStokOpname = 2/*Koreksi Stok*/
						 THEN 1
					ELSE 0
				END AS btnEditKoreksi
			  ,CASE
					WHEN b.idStokOpnameDetail IS NOT NULL
						 THEN 1
					ELSE 0
				END AS btnDelete
		  FROM dbo.farmasiStokOpname a
			   OUTER APPLY (SELECT xa.idStokOpnameDetail, xa.idJenisStokOpname, xa.idObatDetail, xa.idObatDosis
								  ,xa.kodeBatch, xa.tglExpired, xa.hargaPokok, xa.jumlahAwal, xa.jumlahStokOpname
								  ,xa.keterangan
							  FROM dbo.farmasiStokOpnameDetail xa
							 WHERE xa.idStokOpname = a.idStokOpname
							 UNION ALL
							SELECT NULL AS idStokOpnameDetail, NULL AS idJenisStokOpname, xa.idObatDetail, xa.idObatDosis
								  ,xa.kodeBatch, xa.tglExpired, xa.hargaPokok, xa.stok AS jumlahAwal, 0 AS jumlahStokOpname
								  ,NULL AS keterangan
							  FROM dbo.farmasiMasterObatDetail xa
								   LEFT JOIN farmasiStokOpnameDetail xb ON xa.idObatDetail = xb.idObatDetail AND xb.idStokOpname = a.idStokOpname
							 WHERE xa.tglExpired > @nowDate AND xb.idStokOpnameDetail IS NULL AND xa.idJenisStok = a.idJenisStok) b
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
		 WHERE a.idStokOpname = @idSO #dynamicHere#
	  ORDER BY btnEdit DESC, btnEditKoreksi DESC, ba.namaBarang, b.jumlahAwal DESC
		OFFSET '+ @start +' ROWS
	FETCH NEXT '+ @length +' ROWS ONLY';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @idSO = @idStokOpname, @nowDate = @currenctDate, @like = @search;
END