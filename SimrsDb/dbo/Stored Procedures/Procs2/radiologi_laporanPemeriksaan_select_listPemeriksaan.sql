-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_laporanPemeriksaan_select_listPemeriksaan]
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
		   ,@ParamDefinition nvarchar(max) = N'@dateBegin date, @dateEnd date'
		   ,@Filter nvarchar(max) = Case
										 When @idJenisPenjaminInduk <> 0
											  Then ' And da.idJenisPenjaminInduk =  '+ Cast(@idJenisPenjaminInduk As nvarchar(20)) +''
										 Else ''										 									
									 End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = '
		SELECT Distinct a.idMasterTarif, b.namaTarif
		  FROM dbo.transaksiTindakanPasien a
			   Outer Apply dbo.getinfo_tarif(a.idMasterTarif) b
			   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan And c.idJenisRuangan = 10/*Instalasi Radiologi*/
			   Inner Join dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
					Outer Apply dbo.getInfo_penjamin(d.idJenisPenjaminPembayaranPasien) da
		 WHERE Cast(a.tglTindakan As date) Between @dateBegin And @dateEnd #dynamicHere#
	  ORDER BY b.namaTarif
	';
	SET @Query = Replace(@Query, '#dynamicHere#', @Filter);

	EXECUTE sp_executesql @query, @ParamDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir;
END