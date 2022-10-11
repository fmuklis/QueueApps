-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[labor_laporan_pemeriksaanPasien_listPemeriksaan]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @Query nvarchar(max)
		   ,@ParamDefinition nvarchar(max) = N'@dateBegin date, @dateEnd date, @idjpi int'
		   ,@Filter nvarchar(max) = CASE
										 WHEN @idJenisPenjaminInduk <> 0
											  THEN ' And da.idJenisPenjaminInduk = @idjpi'
										 ELSE ''										 									
									 END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = '
		SELECT DISTINCT b.idMasterTarifHeader, b.namaTarif
		  FROM dbo.transaksiTindakanPasien a
			   OUTER APPLY dbo.getinfo_tarif(a.idMasterTarif) b
			   INNER JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan AND c.idJenisRuangan =  4/*Instalasi Laboratorium*/
			   INNER JOIN dbo.transaksiPendaftaranPasien d ON a.idPendaftaranPasien = d.idPendaftaranPasien
					OUTER APPLY dbo.getInfo_penjamin(d.idJenisPenjaminPembayaranPasien) da
		 WHERE a.tglTindakan BETWEEN @dateBegin AND @dateEnd #dynamicHere#
	  ORDER BY b.namaTarif
	';

	SET @Query = Replace(@Query, '#dynamicHere#', @Filter);

	EXECUTE sp_executesql @query, @ParamDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir, @idjpi = @idJenisPenjaminInduk;
END