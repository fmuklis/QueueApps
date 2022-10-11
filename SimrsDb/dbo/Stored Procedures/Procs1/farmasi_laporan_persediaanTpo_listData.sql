-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_laporan_persediaanTpo_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idRuangan int,
	@idObatDosis int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan);
	DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@idjs int, @idod int, @dateBegin date, @dateEnd date'
		   ,@filter nvarchar(max) = CASE
										 WHEN ISNULL(@idObatDosis, 0) <> 0
											  THEN ' AND b.idObatDosis = @idod'
										 ELSE ''
									 END

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = '
		SELECT a.idLog, a.tanggalEntry, b.idObatDosis, ba.namaBarang AS namaObat, ba.satuanBarang AS namaSatuanObat, b.kodeBatch, b.tglExpired
			  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, a.stokAkhir, c.keterangan, c.ruangan
		  FROM dbo.farmasiJurnalStok a
			   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
					OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
			   OUTER APPLY dbo.getInfo_jurnalStokFarmasi(a.idLog) c
		 WHERE CAST(a.tanggalEntry AS date) BETWEEN @dateBegin And @dateEnd And b.idJenisStok = @idjs #dynamicHere#
	  ORDER BY ba.namaBarang, b.idObatDosis, a.idLog
	';

	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir, @idjs = @idJenisStok, @idod = @idObatDosis;
END