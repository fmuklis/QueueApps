-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[labor_laporan_pemeriksaanPasien_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int,
	@idMasterTarifHeader int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @Query nvarchar(max)
		   ,@ParamDefinition nvarchar(max) = N'@dateBegin date, @dateEnd date, @idjpi int, @idmth int'
		   ,@Filter nvarchar(max) = CASE
										 WHEN @idJenisPenjaminInduk <> 0 And @idMasterTarifHeader = 0
											  THEN 'AND db.idJenisPenjaminInduk = @idjpi'
										 WHEN @idJenisPenjaminInduk = 0 And @idMasterTarifHeader <> 0
											  THEN 'AND b.idMasterTarifHeader = @idmth'
										 WHEN @idJenisPenjaminInduk <> 0 And @idMasterTarifHeader <> 0
											  THEN 'AND b.idMasterTarifHeader = @idmth AND db.idJenisPenjaminInduk = @idjpi'
										 ELSE ''										 									
									 END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = '
		SELECT ca.idOrder, a.tglTindakan, db.penjamin, da.noRM, da.namaPasien, cc.namaRuangan, b.namaTarif, e.namaLengkap AS petugas
		  FROM dbo.transaksiTindakanPasien a
			   OUTER APPLY dbo.getinfo_tarif(a.idMasterTarif) b
			   Inner Join dbo.transaksiOrderDetail c On a.idOrderDetail = c.idOrderDetail
					Inner Join dbo.transaksiOrder ca On c.idOrder = ca.idOrder
					Inner Join dbo.masterRuangan cb On ca.idRuanganTujuan = cb.idRuangan And cb.idJenisRuangan = 4/*Instalasi Laboratorium*/
					Inner Join dbo.masterRuangan cc On ca.idRuanganAsal = cc.idRuangan
			   Inner Join dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
					OUTER APPLY dbo.getinfo_datapasien(d.idPasien) da
					OUTER APPLY dbo.getInfo_penjamin(d.idJenisPenjaminPembayaranPasien) db
			   LEFT JOIN dbo.masterUser e ON a.idUserEntry = e.idUser
		 WHERE a.tglTindakan BETWEEN @dateBegin AND @dateEnd #dynamicHere#
	  ORDER BY a.tglTindakan, ca.idOrder, db.penjamin, b.namaTarif
	';

	SET @Query = Replace(@Query, '#dynamicHere#', @Filter);

	EXEC sp_executesql @Query, @ParamDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir, @idjpi = @idJenisPenjaminInduk, @idmth = @idMasterTarifHeader;
END