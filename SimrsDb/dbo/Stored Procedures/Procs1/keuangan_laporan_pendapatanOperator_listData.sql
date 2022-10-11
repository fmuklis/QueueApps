-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_laporan_pendapatanOperator_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idOperator int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @query nvarchar(max)
		   ,@paramDefinition nvarchar(max) = '@dateBegin date, @dateEnd date'
		   ,@columns nvarchar(max)
		   ,@columnsMax nvarchar(max)
		   ,@columnsOpt nvarchar(max)
		   ,@columnsOptMax nvarchar(max)
		   ,@filter nvarchar(max) = '';

	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	SELECT @columns = '[1],[2],[3],[4],[5],[6]'/*STUFF((SELECT ',' + QUOTENAME( DISTINCT b.idMasterKatagoriTarip)
							   FROM dbo.transaksiTindakanPasien a
									INNER JOIN dbo.transaksiTindakanPasienDetail b ON a.idTindakanPasien = b.idTindakanPasien
							  WHERE a.tglTindakan BETWEEN @periodeAwal AND @periodeAkhir
							ORDER BY b.idMasterKatagoriTarip FOR XML PATH('')), 1, 1, '');*/
	SELECT @columnsMax = 'MAX([1]) AS [1],MAX([2]) AS [2],MAX([3]) AS [3],MAX([4]) AS [4],MAX([5]) AS [4],MAX([6]) AS [6]'

	SELECT @columnsOpt = REPLACE(@columns, '[', '[opt'), @columnsOptMax = REPLACE(REPLACE(@columnsMax, '([', '([opt'), 'AS [', 'AS [opt');

	SET @query = '
		WITH dataSet AS (
			SELECT a.tglTindakan, d.namaRuangan, ba.noRM, ba.namaPasien, ea.namaTarifHeader
				  ,ca.idMasterKatagoriTarip
				  ,operatorKategori = ''opt''+ CAST(ca.idMasterKatagoriTarip AS varchar(10))
				  ,cc.NamaOperator, c.nilai
			  FROM dbo.transaksiTindakanPasien a
				   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
						OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
				   LEFT JOIN dbo.transaksiTindakanPasienDetail c ON a.idTindakanPasien = c.idTindakanPasien
						LEFT JOIN dbo.masterTarifKatagori ca ON c.idMasterKatagoriTarip = ca.idMasterKatagoriTarip
						LEFT JOIN dbo.transaksiTindakanPasienOperator cb ON c.idTindakanPasienDetail = cb.idTindakanPasienDetail
						LEFT JOIN dbo.masterOperator cc ON cb.idOperator = cc.idOperator
				   LEFT JOIN dbo.masterRuangan d ON a.idRuangan = d.idRuangan
				   LEFT JOIN dbo.masterTarip e ON a.idMasterTarif = e.idMasterTarif
						LEFT JOIN dbo.masterTarifHeader ea ON e.idMasterTarifHeader = ea.idMasterTarifHeader
			 WHERE a.tglTindakan BETWEEN @dateBegin AND @dateEnd)
		SELECT tglTindakan, namaRuangan, noRM, namaPasien, namaTarifHeader, '+ @columnsMax +', '+ @columnsOptMax +'
		  FROM dataSet
		 PIVOT (MAX(nilai) FOR idMasterKatagoriTarip IN('+ @columns +')) tesData
		 PIVOT (MAX(NamaOperator) FOR operatorKategori IN('+ @columnsOpt +')) operator
	  GROUP BY tglTindakan, namaRuangan, noRM, namaPasien, namaTarifHeader
	';
	--select @query, @columns, @columnsMax;return;
	SET @query = REPLACE(@query, '#dynamicHere#', @filter);

	EXECUTE sp_executesql @query, @paramDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir;
					
END