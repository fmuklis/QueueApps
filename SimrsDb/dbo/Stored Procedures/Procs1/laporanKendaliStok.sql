-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanKendaliStok]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idObatDosis nchar(50)
WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @sql nvarchar(max)
		   ,@paramDefinition nvarchar(max)
		   ,@filter nvarchar(max) = Case
										When @idObatDosis <> 0
											 Then 'And b.idObatDosis = '+ @idObatDosis +''
										Else ''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @sql = '
	SELECT tanggalEntry AS tglProses, idObatDosis, namaObat, namaSatuanObat, kodeBatch, tglExpired, stokAwal, jumlahMasuk, jumlahKeluar, keterangan, namaRuangan
	  FROM (/*Penjualan TPO*/
			SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang As namaObat, ba.namaSatuanObat, b.kodeBatch, b.tglExpired
				  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, ''Resep ''+ cd.namaJenisRuangan +'' No: ''+ cb.noResep As keterangan
				  ,bb.namaJenisStok As namaRuangan
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Outer Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
						Left Join dbo.farmasiMasterObatJenisStok bb On b.idJenisStok = bb.idJenisStok
				   Inner Join dbo.farmasiPenjualanDetail c On a.idPenjualanDetail = c.idPenjualanDetail
						Inner Join dbo.farmasiPenjualanHeader ca On c.idPenjualanHeader = ca.idPenjualanHeader
						Inner Join dbo.farmasiResep cb On ca.idResep = cb.idResep
						Left Join dbo.masterRuangan cc On cb.idRuangan = cc.idRuangan
						Left Join dbo.masterRuanganJenis cd On cc.idJenisRuangan = cd.idJenisRuangan
			 WHERE Cast(a.tanggalEntry As date) Between @dateBegin And @dateEnd #dynamicHere#
			 UNION ALL
		    /*Penjualan BHP*/
		    SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang As namaObat, ba.namaSatuanObat, b.kodeBatch, b.tglExpired
				  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, ''BHP ''+ ce.namaTarifHeader As keterangan
				  ,''BHP Ruangan ''+ cc.Alias As namaRuangan
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Outer Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
				   Inner Join dbo.farmasiPenjualanDetail c On a.idPenjualanDetail = c.idPenjualanDetail
						Inner Join dbo.farmasiPenjualanHeader ca On c.idPenjualanHeader = ca.idPenjualanHeader
						Inner Join dbo.transaksiTindakanPasien cb On c.idTindakanPasien = cb.idTindakanPasien
						Left Join dbo.masterRuangan cc On cb.idRuangan = cc.idRuangan
						Left Join dbo.masterTarip cd On cb.idMasterTarif = cd.idMasterTarif
						Left Join dbo.masterTarifHeader ce On cd.idMasterTarifHeader = ce.idMasterTarifHeader
			 WHERE Cast(a.tanggalEntry As date) Between @dateBegin And @dateEnd #dynamicHere#
			UNION ALL
			/*Pemakaian Internal*/
			SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang As namaObat, ba.namaSatuanObat, b.kodeBatch, b.tglExpired
				  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, ''Pemakain Internal ''+ da.namaBagian As keterangan
				  ,bb.namaJenisStok As namaRuangan
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Outer Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
						Left Join dbo.farmasiMasterObatJenisStok bb On b.idJenisStok = bb.idJenisStok
				   Inner Join dbo.farmasiPemakaianInternal d On a.idPemakaianInternal = d.idPemakaianInternal
						Left Join dbo.farmasiPemakaianInternalBagian da On d.idBagian = da.idBagian
			 WHERE Cast(a.tanggalEntry As date) Between @dateBegin And @dateEnd #dynamicHere#
			UNION ALL
			/*Stok Opname*/
			SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang As namaObat, ba.namaSatuanObat, b.kodeBatch, b.tglExpired
				  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, ''Stok Opname Periode ''+ DateName(month, cb.bulan) +''-''+ Convert(nvarchar(10), cb.tahun) As keterangan
				  ,bb.namaJenisStok As namaRuangan
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Outer Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
						Left Join dbo.farmasiMasterObatJenisStok bb On b.idJenisStok = bb.idJenisStok
				   Inner Join dbo.farmasiStokOpnameDetail c On a.idStokOpnameDetail = c.idStokOpnameDetail
					    Left Join dbo.farmasiStokOpname ca On c.idStokOpname = ca.idStokOpname
						Left Join dbo.farmasiMasterPeriodeStokOpname cb On ca.idPeriodeStokOpname = cb.idPeriodeStokOpname
			 WHERE Cast(a.tanggalEntry As date) Between @dateBegin And @dateEnd #dynamicHere#
			UNION ALL
			/*Mutasi Masuk*/
			SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang As namaObat, ba.namaSatuanObat, b.kodeBatch, b.tglExpired
				  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, ''Mutasi Dari ''+ cc.namaJenisStok As keterangan
				  ,Case
						When cb.idJenisStokTujuan = 6/*BHP Ruangan*/
							 Then cc.namaJenisStok /* +'' ''+ cc.namaRuangan */
						Else cc.namaJenisStok
					End As namaRuangan
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Outer Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
						Left Join dbo.farmasiMasterObatJenisStok bb On b.idJenisStok = bb.idJenisStok
				   Inner Join dbo.farmasiMutasiRequestApproved c On a.idMutasiRequestApproved = c.idMutasiRequestApproved
						Left Join dbo.farmasiMutasiOrderItem ca On c.idItemOrderMutasi = ca.idItemOrderMutasi
						Left Join dbo.farmasiMutasi cb On ca.idMutasi = cb.idMutasi
						Left Join dbo.farmasiMasterObatJenisStok cc On cb.idJenisStokTujuan = cc.idJenisStok
						Left Join dbo.masterRuangan cd On cb.idRuangan = cd.idRuangan 
			 WHERE Cast(a.tanggalEntry As date) Between @dateBegin And @dateEnd And a.jumlahKeluar Is Null #dynamicHere#
			UNION ALL
			/*Mutasi Keluar*/
			SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang As namaObat, ba.namaSatuanObat, b.kodeBatch, b.tglExpired
				  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar
				  ,Case
						When cb.idJenisStokTujuan = 6/*BHP Ruangan*/
							 Then ''Mutasi BHP Ke ''+ cc.Alias
						Else ''Mutasi Ke ''+ ce.namaJenisStok 
					End As keterangan
				  ,ce.namaJenisStok As namaRuangan
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Outer Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
						Left Join dbo.farmasiMasterObatJenisStok bb On b.idJenisStok = bb.idJenisStok
				   Inner Join dbo.farmasiMutasiRequestApproved c On a.idMutasiRequestApproved = c.idMutasiRequestApproved
						Left Join dbo.farmasiMutasiOrderItem ca On c.idItemOrderMutasi = ca.idItemOrderMutasi
						Left Join dbo.farmasiMutasi cb On ca.idMutasi = cb.idMutasi
						Left Join dbo.farmasiMasterObatJenisStok cc On cb.idJenisStokAsal = cc.idJenisStok
						Left Join dbo.masterRuangan cd On cb.idRuangan = cd.idRuangan 
						Left Join dbo.farmasiMasterObatJenisStok ce On cb.idJenisStokTujuan = ce.idJenisStok
			 WHERE Cast(a.tanggalEntry As date) Between @dateBegin And @dateEnd And a.jumlahMasuk Is Null #dynamicHere#
			UNION ALL
			/*Pembelian*/
			SELECT a.tanggalEntry, b.idObatDosis, ba.namaBarang As namaObat, ba.namaSatuanObat, b.kodeBatch, b.tglExpired
				  ,a.stokAwal, a.jumlahMasuk, a.jumlahKeluar, ''Pembelian Ke ''+ cb.namaDistroButor +'' No Faktur: ''+ ca.noFaktur As keterangan
				  ,bb.namaJenisStok As namaRuangan
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Outer Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
						Left Join dbo.farmasiMasterObatJenisStok bb On b.idJenisStok = bb.idJenisStok
				   Inner Join dbo.farmasiPembelianDetail c On a.idPembelianDetail = c.idPembelianDetail
						Left Join dbo.farmasiPembelian ca On c.idPembelianHeader = ca.idPembelianHeader
						Left Join dbo.farmasiMasterDistrobutor cb On ca.idDistrobutor = cb.idDistrobutor		  
			 WHERE Cast(a.tanggalEntry As date) Between @dateBegin And @dateEnd #dynamicHere#) As dataSet
  ORDER BY namaRuangan, namaObat, kodeBatch, tanggalEntry
  ';


  SET @sql = Replace(@sql, '#dynamicHere#', @filter);
  SET @paramDefinition = N'@dateBegin date, @dateEnd date';
  EXECUTE sp_executesql @sql, @paramDefinition, @dateBegin = @periodeAwal, @dateEnd = @periodeAkhir;
  --select @sql;
END