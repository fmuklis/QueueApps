-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_dataPendaftaranPasienRanap]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	If EXISTS(Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling And idStatusKlaim NOT IN (6,7) /*6 = klaim final, 7 = billing dibayar*/)
		Begin
			SELECT a.noSEPRawatInap, g.idBilling, a.idPendaftaranPasien, h.idStatusEklaim, j.idStatusKlaim, i.kodeTarifINACBG, a.noReg
				  ,CAST(a.tanggalRawatInap AS DATE) AS tglInap, CAST(a.tglDaftarPasien AS DATE) AS tglDaftarPasien, CAST(a.tglKeluarPasien AS DATE) AS tglKeluarPasien
				  ,b.kodePasien, b.noRM, b.namaPasien, b.alamatPasien, b.idJenisKelamin, b.namaJenisKelamin, b.bobotLahir AS beratLahir, b.tglLahirPasien
				  ,b.umur,ca.namaJenisPenjaminInduk, a.idDokter, d.diagnosa, f.namaRuangan, kelasPenjamin.kodeKelasBPJS, kelasPenjamin.namaKelas As kelasPenjaminPasien
				  ,a.idDokter, e.NamaOperator As DPJP, c.payPlanId, c.payPlanCode,NULL As kelasEksekutif, NULL As tarifPoliEksekutif, groupTarif.ProsedurNonBedah As tarifProsedurNonBedah
				  ,groupTarif.ProsedurBedah As tarifProsedurBedah, groupTarif.Konsultasi As tarifKonsultasi, groupTarif.TenagaAhli As tarifTenagaAhli
				  ,groupTarif.Keperawatan As tarifKeperawatan, groupTarif.Penunjang As tarifPenunjang, groupTarif.Radiologi As tarifRadiologi, groupTarif.Laboratorium As tarifLaboratorium
				  ,groupTarif.PelayananDarah As tarifPelayananDarah, groupTarif.Rehabilitasi As tarifRehabilitasi, groupTarif.[Kamar/Akomodasi] As tarifKamarAkomodasi
				  ,groupTarif.RawatIntensif As tarifRawatIntensif, groupTarif.Obat As tarifObat, groupTarif.Kronis As tarifObatKronis, groupTarif.Kemoterapi As tarifObatKemoterapi
				  ,groupTarif.Alkes As tarifAlkes, groupTarif.BMHP As tarifBMHP, groupTarif.SewaAlat As tarifSewaAlat, g.cbgKode, g.cbgDescription, g.cbgTarif, g.subAcuteKode, g.subAcuteDescription
				  ,g.subAcuteTarif, g.chronicKode, g.chronicDescription, g.chronicTarif
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
						When IsNull(rawatIntensif.lamaRawatIntensif, 0) > 0
							 Then 1
						Else 0
					End As rawatIntensif, rawatIntensif.lamaRawatIntensif, rawatInap.lamaRawatInap, 0 As pemakaianVentilator
				  ,'Rawat Inap '+ kelasPenjamin.namaKelas As jenisRawat
			  FROM dbo.transaksiPendaftaranPasien a
				   Cross Apply dbo.getinfo_datapasien(a.idPasien) b
				   Left Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
						Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk ca On c.idJenisPenjaminInduk = ca.idJenisPenjaminInduk
				   Outer Apply dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) d
				   Left Join dbo.masterOperator e On a.idDokter = e.idOperator
				   Left Join dbo.masterRuangan f On a.idRuangan = f.idRuangan
				   left Join dbo.transaksiBillingHeader g On a.idPendaftaranPasien = g.idPendaftaranPasien
				   left Join dbo.masterStatusPasien h On a.idStatusPasien = h.idStatusPasien
				   Outer Apply (Select xa.kodeTarifINACBG From dbo.masterKonfigurasi xa) i
				   LEFT JOIN dbo.masterStatusKlaim j ON g.idStatusKlaim = j.idStatusKlaim
				   Left Join dbo.masterKelas kelasPenjamin On a.idKelasPenjaminPembayaran = kelasPenjamin.idKelas
				   OUTER APPLY dbo.calculator_umur(b.tglLahirPasien, a.tglDaftarPasien) k
				   Outer Apply dbo.getinfo_tarifGrouping(a.idPendaftaranPasien) As groupTarif
				   Outer Apply (SELECT SUM(xa.lamaInap) AS lamaRawatIntensif
								  FROM dbo.getInfo_detailBiayaKamarRawatInap(a.idPendaftaranPasien) xa
								 WHERE xa.idMasterTarifGroup = 13) rawatIntensif
				   Outer Apply (SELECT SUM(xa.lamaInap) AS lamaRawatInap
								  FROM dbo.getInfo_detailBiayaKamarRawatInap(a.idPendaftaranPasien) xa
								 WHERE xa.idMasterTarifGroup = 12) rawatInap
			 WHERE g.idBilling = @idBilling;
		End
	Else
		Begin
			SELECT a.noSEPRawatInap, g.idBilling, a.idPendaftaranPasien, h.idStatusEklaim, j.idStatusKlaim, i.kodeTarifINACBG, a.noReg, CAST(a.tanggalRawatInap AS DATE) AS tglInap, CAST(a.tglDaftarPasien AS DATE) AS tglDaftarPasien, CAST(a.tglKeluarPasien AS DATE) AS tglKeluarPasien, b.kodePasien, b.noRM
				  ,b.namaPasien, b.alamatPasien, b.idJenisKelamin, b.namaJenisKelamin, b.bobotLahir AS beratLahir, b.tglLahirPasien, b.umur,ca.namaJenisPenjaminInduk, a.idDokter, d.diagnosa
				  ,f.namaRuangan, kelasPenjamin.kodeKelasBPJS, kelasPenjamin.namaKelas As kelasPenjaminPasien, a.idDokter, e.NamaOperator As DPJP, c.payPlanId, c.payPlanCode
				  ,g.kelasEksekutif, g.tarifPoliEksekutif, g.tarifProsedurNonBedah, g.tarifProsedurBedah, g.tarifKonsultasi, g.tarifTenagaAhli, g.tarifKeperawatan, g.tarifPenunjang
				  ,g.tarifRadiologi, g.tarifLaboratorium, g.tarifPelayananDarah, g.tarifRehabilitasi, g.tarifKamarAkomodasi, g.tarifRawatIntensif, g.tarifObat, g.tarifObatKronis
				  ,g.tarifObatKemoterapi, g.tarifAlkes, g.tarifBMHP, g.tarifSewaAlat
				  ,g.cbgKode, g.cbgDescription, g.cbgTarif, g.subAcuteKode, g.subAcuteDescription, g.subAcuteTarif, g.chronicKode, g.chronicDescription, g.chronicTarif
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
						When IsNull(rawatIntensif.lamaRawatIntensif, 0) > 0
							 Then 1
						Else 0
					End As rawatIntensif, rawatIntensif.lamaRawatIntensif, rawatInap.lamaRawatInap, 0 As pemakaianVentilator
				,'Rawat Inap '+ kelasPenjamin.namaKelas As jenisRawat
			  FROM dbo.transaksiPendaftaranPasien a
				   Cross Apply dbo.getinfo_datapasien(a.idPasien) b
				   Inner Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
						Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk ca On c.idJenisPenjaminInduk = ca.idJenisPenjaminInduk
				   Outer Apply dbo.getInfo_diagnosaPasien(a.idPendaftaranPasien) d
				   Left Join dbo.masterOperator e On a.idDokter = e.idOperator
				   Left Join dbo.masterRuangan f On a.idRuangan = f.idRuangan
				   Left Join dbo.transaksiBillingHeader g On a.idPendaftaranPasien = g.idPendaftaranPasien
				   Left Join dbo.masterStatusPasien h On a.idStatusPasien = h.idStatusPasien
				   Outer Apply (Select xa.kodeTarifINACBG From dbo.masterKonfigurasi xa) i
				   LEFT JOIN dbo.masterStatusKlaim j ON g.idStatusKlaim = j.idStatusKlaim
				   OUTER APPLY dbo.calculator_umur(b.tglLahirPasien, a.tglDaftarPasien) k
				   Left Join dbo.masterKelas kelasPenjamin On a.idKelasPenjaminPembayaran = kelasPenjamin.idKelas
				   Outer Apply (Select Sum(xa.lamaInap) As lamaRawatIntensif
								  From dbo.transaksiPendaftaranPasienDetail xa
									   Inner Join dbo.masterTarifKamar xb On xa.idMasterTarifKamar = xb.idMasterTarifKamar
								 Where xb.idKelas In(6,8,9) And a.idPendaftaranPasien = xa.idPendaftaranPasien) rawatIntensif
				   Outer Apply (Select Sum(xa.lamaInap) As lamaRawatInap
								  From dbo.transaksiPendaftaranPasienDetail xa
									   Inner Join dbo.masterTarifKamar xb On xa.idMasterTarifKamar = xb.idMasterTarifKamar
									   Inner Join dbo.masterKelas xc On xb.idKelas = xc.idKelas
								 Where xc.penjamin = 1 And a.idPendaftaranPasien = xa.idPendaftaranPasien) rawatInap
			 WHERE g.idBilling = @idBilling;
		End
END