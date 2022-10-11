-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectLaporanPoli]
	-- Add the parameters for the stored procedure here
	 @idRuangan int
	,@tglDaftarA date
	,@tglDaftarB date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT namaRuangan, idPendaftaranPasien, tglDaftarPasien, noRM, namaPasien, jenisKelamin , tglLahirPasien, umur, alamatPasien
		  ,namaJenisPenjaminPembayaranPasien, diagnosaAwal, NamaOperator, namaTarifHeader, keterangan
	  FROM (SELECT a.idPendaftaranPasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin, b.tglLahirPasien, b.umur, b.alamatPasien
				  ,a.tglDaftarPasien, d.namaJenisPenjaminPembayaranPasien, f.NamaOperator
				  ,CONCAT(CONVERT(varchar(50), g.tglTindakan, 105), ' ', CONVERT(varchar(50), g.tglTindakan, 108), ' - ', gb.namaTarifHeader) AS namaTarifHeader 
				  ,e.diagnosa AS diagnosaAwal
				  ,Case
						When a.idJenisPerawatan = 1/*Rawat Inap*/
							 Then c.idRuanganAsal
						Else a.idRuangan
					End As idRuangan
				  ,Case
						When a.idJenisPerawatan = 1/*Rawat Inap*/
							 Then 'Rawat Inap'
						Else ''
					End As keterangan
			  FROM dbo.transaksiPendaftaranPasien a 
				   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
				   Left Join dbo.transaksiOrderRawatInap c On a.idPendaftaranPasien = c.idPendaftaranPasien
				   Inner Join dbo.masterJenisPenjaminPembayaranPasien d On a.idJenisPenjaminPembayaranPasien = d.idJenisPenjaminPembayaranPasien
				   OUTER APPLY dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) e
				   Inner Join dbo.masterOperator f On a.idDokter = f.idOperator
				   Inner Join dbo.transaksiTindakanPasien g On a.idPendaftaranPasien = g.idPendaftaranPasien
						Inner Join dbo.masterTarip ga On g.idMasterTarif = ga.idMasterTarif And ga.idKelas = 99
						Inner Join dbo.masterTarifHeader gb On ga.idMasterTarifHeader = gb.idMasterTarifHeader
			 WHERE a.tglDaftarPasien BETWEEN @tglDaftarA AND CONCAT(@tglDaftarB, ' 23:59:59')) AS dataSet
		   Inner Join dbo.masterRuangan b On dataSet.idRuangan = b.idRuangan
	 WHERE b.idRuangan = @idRuangan
  ORDER BY namaRuangan, tglDaftarPasien
END