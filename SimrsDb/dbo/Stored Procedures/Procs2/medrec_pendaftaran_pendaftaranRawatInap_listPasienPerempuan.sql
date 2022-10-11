
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRawatInap_listPasienPerempuan]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, b.noRM, b.namaPasien, b.tglLahirPasien, b.umur, b.namaJenisKelamin As jenisKelamin
		  ,ea.namaJenisPenjaminInduk, d.NamaOperator, f.Alias As namaRuangan, 1 As btnSakit, 1 As btnSehat
	  FROM dbo.transaksiPendaftaranPasien a 
		   Outer Apply dbo.getinfo_datapasien(a.idPasien) b
		   Inner Join dbo.masterOperator d On a.idDokter = d.idOperator		   
		   Inner Join dbo.masterJenisPenjaminPembayaranPasien e On a.idJenisPenjaminPembayaranPasien = e.idJenisPenjaminPembayaranPasien
				 Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk ea On e.idJenisPenjaminInduk = ea.idJenisPenjaminInduk
		   Inner Join dbo.masterRuangan f On a.idRuangan = f.idRuangan And f.idJenisRuangan = 2/*RaNap*/
	 WHERE b.idJenisKelamin = 2 And a.idStatusPendaftaran < 6/*Belum Pulang*/
	 UNION ALL
	SELECT a.idPendaftaranPasien, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, ba.namaJenisKelamin As jenisKelamin
		  ,bd.namaJenisPenjaminInduk, bb.NamaOperator, 'Instalasi Bedah Sentral' As namaRuangan, 1 As btnSakit, 0 As btnSehat
	  FROM dbo.transaksiOrderOK a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
			   Outer Apply dbo.getinfo_datapasien(b.idPasien) ba
			   Inner Join dbo.masterOperator bb On b.idDokter = bb.idOperator		   
			   Inner Join dbo.masterJenisPenjaminPembayaranPasien bc On b.idJenisPenjaminPembayaranPasien = bc.idJenisPenjaminPembayaranPasien
			   Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk bd On bc.idJenisPenjaminInduk = bd.idJenisPenjaminInduk
		   Inner Join dbo.masterRuangan c On a.idRuanganAsal = c.idRuangan And c.idJenisRuangan = 1/*IGD*/
	 WHERE ba.idJenisKelamin = 2 And b.idStatusPendaftaran < 6/*Belum Pulang*/
END