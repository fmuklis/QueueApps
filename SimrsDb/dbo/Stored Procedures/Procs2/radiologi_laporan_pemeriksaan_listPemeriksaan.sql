-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_laporan_pemeriksaan_listPemeriksaan]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idJenisPenjaminInduk int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @query nvarchar(max)
		   ,@where nvarchar(max) = Case
										When @idJenisPenjaminInduk <> 0
											 Then ' And da.idJenisPenjaminInduk = '+Convert(nvarchar(20), @idJenisPenjaminInduk)+''
										Else ''										 									
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Rontgen' AS namaPemeriksaan, 10 AS IGD, 15 AS raJal, 20 AS raNap, 5 AS umum, 25 AS bpjs

	SET @query = 'SELECT idMasterTarif, namaTarifHeader, idJenisRuangan, namaJenisRuangan, Sum(jumlah) As jumlah
					FROM (SELECT a.idMasterTarif, ba.namaTarifHeader, cc.idJenisRuangan, cc.namaJenisRuangan
								,Count(a.idMasterTarif) As jumlah
							FROM dbo.transaksiTindakanPasien a
								 Inner Join dbo.masterTarip b On a.idMasterTarif = b.idMasterTarif
									Inner Join dbo.masterTarifHeader ba On b.idMasterTarifHeader = ba.idMasterTarifHeader
								 Inner Join dbo.transaksiOrderDetail c On a.idOrderDetail = c.idOrderDetail
									Inner Join dbo.transaksiOrder ca On c.idOrder = ca.idOrder And ca.idRuanganTujuan = 6/*Radiologi*/
									Inner Join dbo.masterRuangan cb On ca.idRuanganAsal = cb.idRuangan
									Inner Join dbo.masterRuanganJenis cc On cb.idJenisRuangan = cc.idJenisRuangan
								 Inner Join dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
									Inner Join dbo.masterJenisPenjaminPembayaranPasien da On d.idJenisPenjaminPembayaranPasien = da.idJenisPenjaminPembayaranPasien
						   Where Convert(date, d.tglDaftarPasien) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @where +'
						Group By a.idMasterTarif, ba.namaTarifHeader, cc.idJenisRuangan, cc.namaJenisRuangan) As dataSet
				GROUP BY idMasterTarif, namaTarifHeader, idJenisRuangan, namaJenisRuangan
				ORDER BY namaTarifHeader, namaJenisRuangan';
	EXEC(@query);
END