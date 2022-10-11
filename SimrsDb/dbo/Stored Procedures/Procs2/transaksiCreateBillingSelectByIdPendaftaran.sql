-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[transaksiCreateBillingSelectByIdPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	/*DECLARE @data table(kodePasien nchar(50) ,namaLengkapPasien nvarchar(250) ,namaPenanggungJawabPasien nvarchar(250) null ,namaMasterPelayanan nvarchar(250)
						,idMasterTarif int ,namaTarif nvarchar(250) ,idJenisBilling int null ,namaRuangan nvarchar(250) ,tglTindakan date ,userEntry nvarchar(250) 
						,TglEntry date ,Tarif money ,Jaminan money null,tipeBilling int /* 1 untuk perawatan else farmasi*/);

    -- Insert statements for procedure here

	Insert Into @data
		SELECT ea.kodePasien
			  ,ea.namaLengkapPasien
			  ,e.namaPenanggungJawabPasien
			  ,d.namaMasterPelayanan
			  ,a.idMasterTarif
			  ,b.namaTarif
			  ,(Select Case
							When (Select idMasterPelayanan From dbo.masterTarip Where idMasterTarif = a.idMasterTarif) = 17
								Then 4
							When (Select idMasterPelayanan From dbo.masterTarip Where idMasterTarif = a.idMasterTarif) = 18
								Then 2
							Else 1
						End) As idJenisBilling
			  ,g.namaRuangan
			  ,a.tglTindakan
			  ,f.namaLengkap
			  ,a.TglEntry
			  ,SUM(c.tarip) As Tarif
			  ,null
			  ,1
		FROM  dbo.transaksiTindakanPasien a
			  Inner Join dbo.masterTarip b On a.idMasterTarif=b.idMasterTarif
			  Inner Join dbo.masterTaripDetail c On b.idMasterTarif=c.idMasterTarip
			  Inner Join dbo.masterPelayanan d On b.idMasterPelayanan=d.idMasterPelayanan
			  Inner Join dbo.transaksiPendaftaranPasien e On a.idPendaftaranPasien=e.idPendaftaranPasien
					Inner Join dbo.masterPasien ea On e.idPasien=ea.idPasien
			  Inner join masterUser f on a.idUserEntry=f.idUser
			  Inner join masterRuangan g on a.idRuangan=g.idRuangan
		WHERE a.idPendaftaranPasien = @idPendaftaranPasien
			  And b.idMasterTarif Not In (Select b.idMasterTarif From transaksiBillingHeader a 
												 Inner Join transaksiBillingDetail b On a.idBilling = b.idBilling
										   Where a.idPendaftaranPasien = @idPendaftaranPasien And a.tglBayar Is Not Null )
		GROUP BY ea.kodePasien,ea.namaLengkapPasien,d.namaMasterPelayanan,e.namaPenanggungJawabPasien,a.tglTindakan,a.idMasterTarif, b.namaTarif,a.TglEntry,g.namaRuangan,f.namaLengkap
		ORDER BY  a.TglTindakan;

		Insert Into @data
		SELECT da.kodePasien
			  ,da.namaPasien
			  ,d.namaPenanggungJawabPasien
			  ,'TEBUS RESEP'
			  ,0
			  ,[namaObat]
			  ,0
			  ,'APOTEK / FARMASI'
			  ,a.[tglJual]
			  ,e.namaLengkap
			  ,a.[tglEntry]
			  ,ba.[hargaJual]*[jumlah]
			  ,null
			  ,2
		  FROM [dbo].[farmasiPenjualanHeader] a 
			   Inner Join  [dbo].[farmasiPenjualanDetail] b On a.[idPenjualanHeader]=b.[idPenjualanHeader]
					Inner Join [dbo].[farmasiMasterObat] ba On b.[idObat]=ba.[idObat]
					Inner Join [dbo].[farmasiMasterSatuanObat] bb On ba.[idSatuanObat]=bb.[idSatuanObat]
			   Inner Join [dbo].[farmasiResep] c On a.[idResep] = c.[idResep]
			   Inner Join [dbo].[transaksiPendaftaranPasien] d On c.[idPendaftaranPasien] = d.[idPendaftaranPasien]
					Inner Join (Select * From [dbo].[dataPasien]()) da On d.idpasien = da.idpasien
			   Inner Join masterUser e On a.idUserEntry = e.idUser
		 WHERE d.idPendaftaranPasien = @idPendaftaranPasien And a.[idJenisBayar] = 1 And d.idStatusPendaftaran < 99
      ORDER BY [idRacikan],[namaObat];

	SELECT * FROM @data;*/
END