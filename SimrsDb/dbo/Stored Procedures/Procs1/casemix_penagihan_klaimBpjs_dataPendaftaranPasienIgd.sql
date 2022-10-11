-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_dataPendaftaranPasienIgd]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	If Exists(Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling And ISNULL(idStatusKlaim, 0) <= 4/*Grouping 1*/)
		Begin
			SELECT a.noSEPRawatJalan, g.idBilling, a.idPendaftaranPasien, h.idStatusEklaim, j.idStatusKlaim, i.kodeTarifINACBG, a.noReg
				  ,CAST(a.tglDaftarPasien AS smalldatetime) AS tglDaftarPasien, b.kodePasien, b.noRM
				  ,b.namaLengkapPasien, b.namaPasien, b.alamatPasien, b.idJenisKelamin, b.namaJenisKelamin, b.bobotLahir AS beratLahir
				  ,b.tglLahirPasien, b.umur,ca.namaJenisPenjaminInduk, a.idDokter, d.diagnosa, f.namaRuangan, kelasPenjamin.idKelas
				  ,kelasPenjamin.namaKelas As kelasPenjaminPasien, a.idDokter, e.NamaOperator As DPJP, c.payPlanId, c.payPlanCode
				  ,NULL As kelasEksekutif, NULL As tarifPoliEksekutif, groupTarif.ProsedurNonBedah As tarifProsedurNonBedah, groupTarif.ProsedurBedah As tarifProsedurBedah
				  ,groupTarif.Konsultasi As tarifKonsultasi, groupTarif.TenagaAhli As tarifTenagaAhli, groupTarif.Keperawatan As tarifKeperawatan, groupTarif.Penunjang As tarifPenunjang
				  ,groupTarif.Radiologi As tarifRadiologi, groupTarif.Laboratorium As tarifLaboratorium, groupTarif.PelayananDarah As tarifPelayananDarah
				  ,groupTarif.Rehabilitasi As tarifRehabilitasi, groupTarif.[Kamar/Akomodasi] As tarifKamarAkomodasi, groupTarif.RawatIntensif As tarifRawatIntensif, groupTarif.Obat As tarifObat, groupTarif.Kronis As tarifObatKronis
				  ,groupTarif.Kemoterapi As tarifObatKemoterapi, groupTarif.Alkes As tarifAlkes, groupTarif.BMHP As tarifBMHP, groupTarif.SewaAlat As tarifSewaAlat
				  ,g.cbgKode, g.cbgDescription, g.cbgTarif, g.subAcuteKode, g.subAcuteDescription, g.subAcuteTarif, g.chronicKode, g.chronicDescription, g.chronicTarif
				  ,CASE WHEN CAST(a.tglKeluarPasien AS time(0)) = '00:00:00'
							 THEN CONCAT(CAST(a.tglKeluarPasien AS date), ' ', CAST(DATEADD(HOUR, 3, a.tglDaftarPasien) AS time(0)))
						ELSE a.tglKeluarPasien
					END AS tglKeluarPasien
				  ,Case
						When k.satuanUmur = 'Minggu'
							 Then b.namaPasien
						Else b.namaLengkapPasien
					End As namaLengkapPasien				  
				  ,Case
						When Len(Trim(b.noPenjamin)) < 4
							 Then b.noDokumenIdentitasPasien
						Else b.noPenjamin
					End As noKartu
				  ,Case
						When g.kelasEksekutif = 1
							 Then 'Rawat Jalan Eksekutif'
						Else 'Rawat Jalan Reguler'
					End As jenisRawat
			  FROM dbo.transaksiPendaftaranPasien a
				   Cross Apply dbo.getinfo_datapasien(a.idPasien) b
				   Left Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
						Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk ca On c.idJenisPenjaminInduk = ca.idJenisPenjaminInduk
				   Outer Apply dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) d
				   Left Join dbo.masterOperator e On a.idDokter = e.idOperator
				   Left Join dbo.masterRuangan f On a.idRuangan = f.idRuangan
				   Inner Join dbo.transaksiBillingHeader g On a.idPendaftaranPasien = g.idPendaftaranPasien
				   Inner Join dbo.masterStatusPasien h On a.idStatusPasien = h.idStatusPasien
				   Outer Apply (Select xa.kodeTarifINACBG From dbo.masterKonfigurasi xa) i
				   LEFT JOIN dbo.masterStatusKlaim j ON g.idStatusKlaim = j.idStatusKlaim
				   OUTER APPLY dbo.calculator_umur(b.tglLahirPasien, a.tglDaftarPasien) k
				   Left Join dbo.masterKelas kelasPenjamin On a.idKelasPenjaminPembayaran = kelasPenjamin.idKelas
				   Outer Apply dbo.getinfo_tarifGrouping(a.idPendaftaranPasien) As groupTarif
			 WHERE g.idBilling = @idBilling;
		End
	Else
		Begin
			SELECT a.noSEPRawatJalan, g.idBilling, a.idPendaftaranPasien, h.idStatusEklaim, j.idStatusKlaim, i.kodeTarifINACBG, a.noReg, CAST(a.tglDaftarPasien AS smalldatetime) AS tglDaftarPasien, b.kodePasien, b.noRM
				  ,b.namaLengkapPasien, b.namaPasien, b.alamatPasien, b.idJenisKelamin, b.namaJenisKelamin, b.bobotLahir AS beratLahir, b.tglLahirPasien, b.umur,ca.namaJenisPenjaminInduk, a.idDokter, d.diagnosa
				  ,f.namaRuangan, kelasPenjamin.idKelas, kelasPenjamin.namaKelas As kelasPenjaminPasien, a.idDokter, e.NamaOperator As DPJP, c.payPlanId, c.payPlanCode
				  ,g.kelasEksekutif, g.tarifPoliEksekutif, g.tarifProsedurNonBedah, g.tarifProsedurBedah, g.tarifKonsultasi, g.tarifTenagaAhli, g.tarifKeperawatan, g.tarifPenunjang
				  ,g.tarifRadiologi, g.tarifLaboratorium, g.tarifPelayananDarah, g.tarifRehabilitasi, g.tarifKamarAkomodasi, g.tarifRawatIntensif, g.tarifObat, g.tarifObatKronis
				  ,g.tarifObatKemoterapi, g.tarifAlkes, g.tarifBMHP, g.tarifSewaAlat
				  ,g.cbgKode, g.cbgDescription, g.cbgTarif, g.subAcuteKode, g.subAcuteDescription, g.subAcuteTarif, g.chronicKode, g.chronicDescription, g.chronicTarif
				  ,CASE WHEN CAST(a.tglKeluarPasien AS time(0)) = '00:00:00'
							 THEN CONCAT(CAST(a.tglKeluarPasien AS date), ' ', CAST(DATEADD(HOUR, 3, a.tglDaftarPasien) AS time(0)))
						ELSE a.tglKeluarPasien
					END AS tglKeluarPasien
				  ,Case
						When k.satuanUmur = 'Minggu'
							 Then b.namaPasien
						Else b.namaLengkapPasien
					End As namaLengkapPasien				  
				  ,Case
						When Len(Trim(b.noPenjamin)) < 4
							 Then b.noDokumenIdentitasPasien
						Else b.noPenjamin
					End As noKartu
				  ,Case
						When g.kelasEksekutif = 1
							 Then 'Rawat Jalan Eksekutif'
						Else 'Rawat Jalan Reguler'
					End As jenisRawat
			  FROM dbo.transaksiPendaftaranPasien a
				   Cross Apply dbo.getinfo_datapasien(a.idPasien) b
				   Inner Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
						Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk ca On c.idJenisPenjaminInduk = ca.idJenisPenjaminInduk
				   Outer Apply dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) d
				   Left Join dbo.masterOperator e On a.idDokter = e.idOperator
				   Left Join dbo.masterRuangan f On a.idRuangan = f.idRuangan
				   Inner Join dbo.transaksiBillingHeader g On a.idPendaftaranPasien = g.idPendaftaranPasien
				   Inner Join dbo.masterStatusPasien h On a.idStatusPasien = h.idStatusPasien
				   Outer Apply (Select xa.kodeTarifINACBG From dbo.masterKonfigurasi xa) i
				   LEFT JOIN dbo.masterStatusKlaim j ON g.idStatusKlaim = j.idStatusKlaim
				   OUTER APPLY dbo.calculator_umur(b.tglLahirPasien, a.tglDaftarPasien) k
				   Left Join dbo.masterKelas kelasPenjamin On a.idKelasPenjaminPembayaran = kelasPenjamin.idKelas
			 WHERE g.idBilling = @idBilling;
		End
END