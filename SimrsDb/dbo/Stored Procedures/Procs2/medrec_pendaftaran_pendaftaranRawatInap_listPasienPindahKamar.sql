-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRawatInap_listPasienPindahKamar] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idOrderPindahKamar, b.idPendaftaranPasien, tglOrderPindahKamar, bd.namaJenisPenjaminInduk, bb.noRM, bb.namaPasien
		  ,bh.Alias +' / '+ bg.namaRuanganRawatInap +' Bed: '+ Convert(nvarchar(10), bf.noTempatTidur) As namaRuangan, a.keterangan
		  ,Case
				When be.idStatusPendaftaranRawatInap = 1/*Sesuai Kelas*/ AND ba.idPendaftaranIbu IS NULL
					 Then 1
				Else 0
			End As pindahInap
			 ,Case
				When be.idStatusPendaftaranRawatInap = 2/*Pasien BPJS Naik Kelas*/
					 Then 1
				Else 0
			End As pindahNaikKelas
		  ,Case
				When be.idStatusPendaftaranRawatInap = 3/*Pasien Titip Inap*/
					 Then 1
				Else 0
			End As pindahTitipInap
		 ,Case
				When ba.idPendaftaranIbu is not null
					 Then 1
				Else 0
			End As pindahRanapBayi
	  FROM dbo.transaksiOrderRawatInapPindahKamar a
		   Inner Join dbo.transaksiOrderRawatInap b On a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
				Inner Join dbo.transaksiPendaftaranPasien ba On b.idPendaftaranPasien = ba.idPendaftaranPasien
				outer apply dbo.getInfo_dataPasien(ba.idPasien) bb
				Inner Join dbo.masterJenisPenjaminPembayaranPasien bc On ba.idJenisPenjaminPembayaranPasien = bc.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk bd On bc.idJenisPenjaminInduk = bd.idJenisPenjaminInduk
				Inner Join dbo.transaksiPendaftaranPasienDetail be On b.idPendaftaranPasien = be.idPendaftaranPasien And be.aktif = 1/*Aktif*/
				Inner Join dbo.masterRuanganTempatTidur bf On be.idTempatTidur = bf.idTempatTidur
				Inner Join dbo.masterRuanganRawatInap bg On bf.idRuanganRawatInap = bg.idRuanganRawatInap
				Inner Join dbo.masterRuangan bh On bg.idRuangan = bh.idRuangan
	 WHERE a.flagStatus = 0
	ORDER BY a.tglOrderPindahKamar
END