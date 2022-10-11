-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_kendaliStok_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idObatDosis int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@dateBegin date, @dateEnd date, @idod int'
		   ,@filter nvarchar(max) = CASE
										 WHEN @idObatDosis <> 0
											  THEN 'AND b.idObatDosis = @idod'
										 ELSE ''
									 END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @sql = '
		SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang, ba.satuanBarang, b.kodeBatch, b.tglExpired
			  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, a.stokAkhir, c.keterangan, c.ruangan
		  FROM dbo.farmasiJurnalStok a
			   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
					OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
			   OUTER APPLY dbo.getInfo_jurnalStokFarmasi(a.idLog) c
		 WHERE CAST(a.tanggalEntry AS date) BETWEEN @dateBegin AND @dateEnd #dynamicHere#
	  ORDER BY c.ruangan, ba.namaBarang, b.kodeBatch, a.idLog
  ';

  SET @sql = Replace(@sql, '#dynamicHere#', @filter);

  EXECUTE sp_executesql @sql, @paramDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir, @idod = @idObatDosis;
END