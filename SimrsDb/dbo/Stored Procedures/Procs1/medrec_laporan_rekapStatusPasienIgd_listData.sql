-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rekapStatusPasienIgd_listData]
	-- Add the parameters for the stored procedure here
	@tahun int,
	@bulan int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@year int, @month int'
		   ,@columns nvarchar(max)
		   ,@filter nvarchar(max) = CASE
										WHEN @bulan = 0
											 THEN 'AND YEAR(a.tglDaftarPasien) = @year'
										ELSE 'AND YEAR(a.tglDaftarPasien) = @year AND MONTH(a.tglDaftarPasien) = @month'										 									
									END

	SELECT @columns = STUFF((SELECT DISTINCT ',[' + REPLACE(a.namaStatusPasien, ' ', '') +']'
							   FROM dbo.masterStatusPasien a
									INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idStatusPasien = b.idStatusPasien
   							  WHERE b.idJenisPendaftaran = 1/*IGD*/ AND b.idJenisPerawatan = 2/*RaJal*/
									AND YEAR(b.tglDaftarPasien) = @tahun
						FOR XML PATH ('')), 1, 1, '');

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SET @query = 'WITH dataSrc AS(
						SELECT a.idPelayananIGD, REPLACE(b.namaStatusPasien, '' '', '''') AS namaStatusPasien, COUNT(a.idPendaftaranPasien) AS jumlah
						  FROM dbo.transaksiPendaftaranPasien a
							   INNER JOIN dbo.masterStatusPasien b ON a.idStatusPasien = b.idStatusPasien
						 WHERE a.idJenisPendaftaran = 1/*IGD*/ AND a.idJenisPerawatan = 2/*RaJal*/ #dynamicHere#
					  GROUP BY a.idPelayananIGD, b.namaStatusPasien)
				SELECT *
				  FROM (SELECT a.namaPelayananIGD, b.namaStatusPasien, b.jumlah
						  FROM dbo.masterPelayananIGD a
							   LEFT JOIN dataSrc b ON a.idPelayananIGD = b.idPelayananIGD) pvtSrc
				PIVOT (MAX(jumlah) FOR namaStatusPasien IN('+ @columns +')) pvtData';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @year = @tahun, @month = @bulan;
END