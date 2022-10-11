-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_rekapPenjualan_dataPenjualan]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @columns nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@dateBegin date, @dateEnd date'
		   ,@query nvarchar(max);

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SET @columns = STUFF((SELECT ',' + QUOTENAME(alias) FROM farmasiMasterObatJenisStok ORDER BY idJenisStok FOR XML PATH('')), 1, 1, '');

	SET @query = '
		SELECT namaObat, namaSatuanObat, '+ @columns +'
		  FROM (SELECT b.namaObat, b.namaSatuanObat, c.jumlah
					  ,CASE
							WHEN a.idJenisStok = 6 OR a.idJenisStok IS NULL/*BHP Ruangan*/
								 THEN ''BHP''
							ELSE d.alias
						END AS unitPenjualan
				  FROM dbo.farmasiMasterObatDetail a
					   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
					   INNER JOIN dbo.farmasiPenjualanDetail c ON a.idObatDetail = c.idObatDetail
							LEFT JOIN dbo.farmasiPenjualanHeader ca ON c.idPenjualanHeader = ca.idPenjualanHeader
							LEFT JOIN dbo.transaksiTindakanPasien cb ON c.idTindakanPasien = cb.idTindakanPasien
					   LEFT JOIN dbo.farmasiMasterObatJenisStok d ON a.idJenisStok = d.idJenisStok
				 WHERE (ca.tglJual BETWEEN @dateBegin AND @dateEnd) OR (cb.tglTindakan BETWEEN @dateBegin AND @dateEnd)) AS listData
		PIVOT (SUM(jumlah) FOR unitPenjualan IN('+ @columns +')) AS dataSet
	 ORDER BY namaObat, namaSatuanObat';
	 --select @query;return;
	 EXECUTE sp_executesql @query, @paramDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir;
END