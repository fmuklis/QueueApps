-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Detil Biaya Berdasarkan idOrder
-- =============================================
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_listPelayananByIdPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idKelasPelayanan int
			,@level int;

		Select @idKelasPelayanan = c.idKelas, @level = ca.level 
		  From transaksiPendaftaranPasien a
			   Inner Join masterRuanganTempatTidur b On a.idTempatTidur = b.idTempatTidur
			   Inner Join masterRuanganRawatInap c On b.idRuanganRawatInap = c.idRuanganRawatInap
					Inner Join masterKelas ca On c.idKelas = ca.idKelas
		 Where a.idPendaftaranPasien = @idPendaftaranPasien And idOrderRawatInap = 4;

	SET NOCOUNT ON;
	DECLARE @data table(idPendaftaranPasien int ,tglOrder date ,idMasterTarif int ,namaTarif nvarchar(250)
						,namaMasterPelayanan nvarchar(250) ,Tarif money ,Jaminan money null,namaRuangan nvarchar(250) ,namaLengkap nvarchar(250) ,idJenisBilling int ,tipeBilling int);
    
	-- Insert statements for procedure here
	/*If Exists (Select 1 From transaksiPendaftaranPasien Where idOrderRawatInap = 4 And idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			If Exists(Select 1 From transaksiPenjaminPembayaranPasien a Inner Join masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
									Inner Join masterKelas c On a.idKelas = c.idKelas
							  Where idPendaftaranPasien = @idPendaftaranPasien And b.flagKenakelas <> 0
									And a.idKelas <> @idKelasPelayanan
									And c.level > @level)
				Begin
					INSERT INTO @data
						SELECT a.[idPendaftaranPasien] 
							  ,a.tglOrder
							  ,b.idMasterTarif 
							  ,cb.namaTarifHeader As namaTarif 
							  ,ca.namaMasterPelayanan
							  ,sum(d.tarip)
							  ,(Select SUM(xb.tarip) From masterTarip xa
														   Inner Join masterTaripDetail xb On xa.idMasterTarif = xb.idMasterTarip
													 Where xa.namaTarif = cb.namaTarifHeader And xa.idMasterPelayanan = c.idMasterPelayanan
														   And xa.idKelas = (Select idKelas From transaksiPenjaminPembayaranPasien 
																							Where idPendaftaranPasien = @idPendaftaranPasien))
							  ,e.namaRuangan
							  ,f.namaLengkap
							  ,Case
									When ea.idJenisRuangan = 4
										Then 2
									When ea.idJenisRuangan = 10
										Then 4
									When ea.idJenisRuangan = 13
										Then 3
								End as idJenisBilling
							   ,1
						  FROM dbo.transaksiOrder a 
							   Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
							   Inner Join dbo.masterTarip c On b.idMasterTarif = c.idMasterTarif
									Inner Join dbo.masterPelayanan ca On c.idMasterPelayanan = ca.idMasterPelayanan
									Inner Join dbo.masterTarifHeader cb On c.idMasterTarifHeader = cb.idMasterTarifHeader
							   Inner Join dbo.masterTaripDetail d On b.idMasterTarif =d.idMasterTarip
							   Inner Join dbo.masterRuangan e On a.idRuanganTujuan = e.idRuangan
									Inner Join dbo.masterRuanganJenis ea On e.idJenisRuangan = ea.idJenisRuangan  
							   Inner Join dbo.masterUser f On a.idUserEntry = f.idUser
						 WHERE a.idPendaftaranPasien = @idPendaftaranPasien --And a.idStatusOrder =3
					  GROUP BY a.idOrder,a.[idPendaftaranPasien] ,a.tglOrder ,b.idMasterTarif ,c.idMasterPelayanan ,cb.namaTarifHeader ,ca.namaMasterPelayanan ,e.namaRuangan ,ea.idJenisRuangan ,f.namaLengkap
					  ORDER BY ca.namaMasterPelayanan,cb.namaTarifHeader;

					INSERT INTO @data
							SELECT d.idPendaftaranPasien 
								  ,c.[tglResep]
								  ,0
								  ,[namaObat]
								  ,'TEBUS RESEP'
								  ,ba.[hargaJual]*[jumlah]
								  ,ba.[hargaJual]*[jumlah]
								  ,'APOTEK / FARMASI'
								  ,e.namaLengkap
								  ,0
								  ,2
							  FROM [dbo].[farmasiPenjualanHeader] a 
								   Inner Join  [dbo].[farmasiPenjualanDetail] b On a.[idPenjualanHeader]=b.[idPenjualanHeader]
										Inner Join [dbo].[farmasiMasterObat] ba On b.[idObat]=ba.[idObat]
										Inner Join [dbo].[farmasiMasterSatuanObat] bb On ba.[idSatuanObat]=bb.[idSatuanObat]
								   Inner Join [dbo].[farmasiResep] c On a.[idResep] = c.[idResep]
								   Inner Join [dbo].[transaksiPendaftaranPasien] d On c.[idPendaftaranPasien] = d.[idPendaftaranPasien]
										Inner Join (Select * From [dbo].[dataPasien]()) da On d.idpasien = da.idpasien
								   Inner Join masterUser e On a.idUserEntry = e.idUser
							 WHERE d.idPendaftaranPasien = @idPendaftaranPasien And a.[idJenisBayar] = 2 And d.idStatusPendaftaran < 99
						  ORDER BY [idRacikan],[namaObat];
					SELECT 1 As responCode, * FROM @data;
				End
		End
	Else
		Begin
			INSERT INTO @data
				SELECT a.[idPendaftaranPasien] 
					  ,a.tglOrder
					  ,b.idMasterTarif 
					  ,cb.namaTarifHeader As namaTarif 
					  ,ca.namaMasterPelayanan
					  ,sum(d.tarip)
					  ,null
					  ,e.namaRuangan
					  ,f.namaLengkap
					  ,Case
							When ea.idJenisRuangan = 4
								Then 2
							When ea.idJenisRuangan = 10
								Then 4
							When ea.idJenisRuangan = 13
								Then 3
						End as idJenisBilling
					   ,1
				  FROM dbo.transaksiOrder a 
					   Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
					   Inner Join dbo.masterTarip c On b.idMasterTarif = c.idMasterTarif
							Inner Join dbo.masterPelayanan ca On c.idMasterPelayanan = ca.idMasterPelayanan
							Inner Join dbo.masterTarifHeader cb On c.idMasterTarifHeader = cb.idMasterTarifHeader
					   Inner Join dbo.masterTaripDetail d On b.idMasterTarif =d.idMasterTarip
					   Inner Join dbo.masterRuangan e On a.idRuanganTujuan = e.idRuangan
							Inner Join dbo.masterRuanganJenis ea On e.idJenisRuangan = ea.idJenisRuangan  
					   Inner Join dbo.masterUser f On a.idUserEntry = f.idUser
					   Inner Join [dbo].[transaksiTindakanPasien] g On a.idPendaftaranPasien = g.idPendaftaranPasien
							Inner Join [dbo].[transaksiTindakanPasienOperator] ga On g.[idTindakanPasien] = ga.[idTindakanPasien]
				 WHERE a.idPendaftaranPasien = @idPendaftaranPasien --And a.idStatusOrder =3
			  GROUP BY a.[idPendaftaranPasien] ,a.tglOrder ,b.idMasterTarif ,cb.namaTarifHeader ,ca.namaMasterPelayanan ,e.namaRuangan ,ea.idJenisRuangan ,f.namaLengkap
			  ORDER BY ca.namaMasterPelayanan, cb.namaTarifHeader;

				INSERT INTO @data
					SELECT d.idPendaftaranPasien 
						  ,c.[tglResep]
						  ,0
						  ,[namaObat]
						  ,'TEBUS RESEP'
						  ,ba.[hargaJual]*[jumlah]
						  ,null
						  ,'APOTEK / FARMASI'
						  ,e.namaLengkap
						  ,0
						  ,2
					  FROM [dbo].[farmasiPenjualanHeader] a 
						   Inner Join  [dbo].[farmasiPenjualanDetail] b On a.[idPenjualanHeader]=b.[idPenjualanHeader]
								Inner Join [dbo].[farmasiMasterObat] ba On b.[idObat]=ba.[idObat]
								Inner Join [dbo].[farmasiMasterSatuanObat] bb On ba.[idSatuanObat]=bb.[idSatuanObat]
						   Inner Join [dbo].[farmasiResep] c On a.[idResep] = c.[idResep]
						   Inner Join [dbo].[transaksiPendaftaranPasien] d On c.[idPendaftaranPasien] = d.[idPendaftaranPasien]
								Inner Join (Select * From [dbo].[dataPasien]()) da On d.idpasien = da.idpasien
						   Inner Join masterUser e On a.idUserEntry = e.idUser
					 WHERE d.idPendaftaranPasien = @idPendaftaranPasien And a.[idJenisBayar] = 2 And d.idStatusPendaftaran < 99
				  ORDER BY [idRacikan],[namaObat];
			SELECT 0 As responCode, * FROM @data;
		End*/
END