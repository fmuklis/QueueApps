-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_laporanPemeriksaan_select_listData]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int,
	@idMasterTarif int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @Query nvarchar(max)
		   ,@ParamDefinition nvarchar(max) = N'@dateBegin date, @dateEnd date'
		   ,@Filter nvarchar(max) = Case
										 When @idJenisPenjaminInduk <> 0 And @idMasterTarif = 0
											  Then 'And db.idJenisPenjaminInduk = '+ Cast(@idJenisPenjaminInduk As nvarchar(20)) +''
										 When @idJenisPenjaminInduk = 0 And @idMasterTarif <> 0
											  Then 'And a.idMasterTarif = '+ Cast(@idMasterTarif As nvarchar(20)) +''
										 When @idJenisPenjaminInduk <> 0 And @idMasterTarif <> 0
											  Then 'And a.idMasterTarif = '+ Cast(@idMasterTarif As nvarchar(20)) +' And db.idJenisPenjaminInduk =  '+ Cast(@idJenisPenjaminInduk As nvarchar(20)) +''
										 Else ''										 									
									 End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = '
		SELECT ca.idOrder, a.tglTindakan, dc.penjamin, dbo.format_medicalRecord(da.kodePasien) AS noRM
			  ,db.namaPasien, cc.namaRuangan, b.namaTarif, e.namaLengkap AS petugas
		  FROM dbo.transaksiTindakanPasien a
			   OUTER APPLY dbo.getinfo_tarif(a.idMasterTarif) b
			   INNER JOIN dbo.transaksiOrderDetail c On a.idOrderDetail = c.idOrderDetail
					INNER JOIN dbo.transaksiOrder ca On c.idOrder = ca.idOrder
					INNER JOIN dbo.masterRuangan cb On ca.idRuanganTujuan = cb.idRuangan And cb.idJenisRuangan = 10/*Instalasi Radiologi*/
					INNER JOIN dbo.masterRuangan cc On ca.idRuanganAsal = cc.idRuangan
			   INNER JOIN dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
					INNER JOIN dbo.masterPasien da ON d.idPasien = da.idPasien
					OUTER APPLY dbo.generate_namaPasien(da.tglLahirPasien, d.tglDaftarPasien, da.idJenisKelaminPasien, da.idStatusPerkawinanPasien, da.namaLengkapPasien, da.namaAyahPasien) db
					OUTER APPLY dbo.getInfo_penjamin(d.idJenisPenjaminPembayaranPasien) dc
			   LEFT JOIN dbo.masterUser e ON a.idUserEntry = e.idUser
		 WHERE Cast(a.tglTindakan As date) Between @dateBegin And @dateEnd #dynamicHere#
	  ORDER BY a.tglTindakan, ca.idOrder, dc.penjamin, b.namaTarif
	';
	SET @Query = Replace(@Query, '#dynamicHere#', @Filter);

	EXEC sp_executesql @Query, @ParamDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir;
END