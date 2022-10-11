
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPendaftaranPasienBayiSakit]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idOperator int
    ,@idTempatTidur int
	,@tglDaftar datetime
    ,@userIdEntry int
    ,@keterangan nvarchar(max)
	,@idJenisKelaminPasien int
	,@tglLahirPasien date
	,@namaAyah nvarchar(250)
	,@anakKePasien int
	

AS
BEGIn
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@idKelasKamar int
		   ,@idPasien int
		   ,@idPendaftaranBayi int
		   ,@idTransaksiOrderRawatInap int;

	 Select @idRuangan = a.idRuangan, @idmasterTarifKamar = ba.idMasterTarifKamar, @hargaPokok = ba.hargaPokok
		   ,@tarifKamar = ba.tarif, @idKelasKamar = b.idKelas
	   From dbo.masterRuangan a
			Inner Join dbo.masterRuanganRawatInap b On a.idRuangan = b.idRuangan
				Inner Join dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
				Inner Join dbo.masterRuanganTempatTidur bb On b.idRuanganRawatInap = bb.idRuanganRawatInap
	  Where bb.idTempatTidur = @idTempatTidur;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Periksa Billing Rawat Jalan
	If @idMastertarifkamar Is Null
		Begin
			Select 'Gagal!: Tarif Kelas Kamar '+ a.namaKelas +' Belum Memiliki Tarif, Segera Hubungi Keuangan' As respon, 0 As responCode
			  From dbo.masterKelas a
				   Inner Join dbo.masterRuanganRawatInap b On a.idKelas = b.idKelas
						Inner Join dbo.masterRuanganTempatTidur bb On b.idRuanganRawatInap = bb.idRuanganRawatInap
			 Where bb.idTempatTidur = @idTempatTidur;
		End
	Else
		Begin Try
			Begin Tran;
			/*Enrtry Data Bayi*/
			INSERT INTO [dbo].[masterPasien]
					   ([kodePasien]
					   ,[namaLengkapPasien]
					   ,[idPekerjaanPasien]
					   ,[tempatLahirPasien]
					   ,[tglLahirPasien]
					   ,[idJenisKelaminPasien]
					   ,[alamatPasien]
					   ,[idDesaKelurahanPasien]
					   ,[namaAyahPasien]
					   ,[namaIbuPasien]
					   ,[anakKePasien]
					   ,[idDokumenIdentitasPasien]
					   ,[noDokumenIdentitasPasien]
					   ,[idPendidikanPasien]
					   ,[idAgamaPasien]
					   ,[idWargaNegaraPasien]
					   ,[idStatusPerkawinanPasien])
				 SELECT dbo.generate_nomorRekamMedis()
					   ,b.namaLengkapPasien
					   ,14/*Belum Bekerja*/
					   ,c.kota
					   ,@tglLahirPasien
					   ,@idJenisKelaminPasien
					   ,b.alamatPasien
					   ,b.idDesaKelurahanPasien
					   ,@namaAyah
					   ,b.namaIbuPasien
					   ,@anakKePasien
					   ,9/*Surat Keterangan Kelahiran*/
					   ,'-'
					   ,2/*Belum Sekolah*/
					   ,b.idAgamaPasien
					   ,b.idWargaNegaraPasien
					   ,1/*Belum Menikah*/
				   FROM dbo.transaksiPendaftaranPasien a
						INNER JOIN dbo.masterPasien b ON a.idPasien = b.idPasien
						OUTER APPLY (SELECT kota FROM dbo.masterRumahSakit) c
				  WHERE a.idPendaftaranPasien = @idPendaftaranPasien;

			/*GET idPasien*/
			SET @idPasien = SCOPE_IDENTITY();

			/*Pendaftaran Bayi*/
			INSERT INTO [dbo].[transaksiPendaftaranPasien]
					   ([noReg]
					   ,[idPasien]
					   ,[idPendaftaranIbu]
					   ,[idJenisPendaftaran]
					   ,[idJenisPerawatan]
					   ,[tglDaftarPasien]
					   ,[idAsalPasien]
					   ,[namaTempatAsalPasien]
					   ,[idRuangan]
					   ,[idKelas]
					   ,[idUser]
					   ,[tglEntry]
					   ,[idStatusPendaftaran]
					   ,[idJenisPenjaminPembayaranPasien]
					   ,[idKelasPenjaminPembayaran]
					   ,[idDokter]
					   ,[namaPenanggungJawabPasien]
					   ,[idHubunganKeluargaPenanggungJawab])
				 SELECT dbo.noRegister()
					   ,@idPasien
					   ,@idPendaftaranPasien
					   ,a.idJenisPendaftaran
					   ,1/*RaNap*/
					   ,@tglDaftar
					   ,a.idAsalPasien
					   ,''
					   ,@idRuangan
					   ,@idKelasKamar
					   ,@userIdEntry
					   ,getdate()
					   ,5/*Validasi Kasir Bayar Kartu Jaga*/
					   ,a.idJenisPenjaminPembayaranPasien
					   ,a.idKelasPenjaminPembayaran
					   ,@idOperator
					   ,@namaAyah
					   ,3/*Ayah*/
				   FROM dbo.transaksiPendaftaranPasien a
				  WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
				
			/*GET idPendaftaranBayi*/	
			SET @idPendaftaranBayi = SCOPE_IDENTITY();

			/*INSERT Entry Order Pendaftaran Rawat Inap*/
			INSERT INTO [dbo].[transaksiOrderRawatInap]
						   ([idStatusOrderRawatInap]
						   ,[idPendaftaranPasien]
						   ,[idRuanganAsal]
						   ,[tglOrder])
					 SELECT 2/*Selesai Pendaftaran*/
						   ,@idPendaftaranBayi
						   ,a.idRuangan
						   ,GetDate()
					   FROM dbo.transaksiPendaftaranPasien a
					  WHERE a.idPendaftaranPasien = @idPendaftaranPasien;

			/*GET idTransaksiOrderRawatInap*/
			SET @idTransaksiOrderRawatInap = SCOPE_IDENTITY();
					
			/*INSERT Data Pendaftaran Rawat Inap*/	  				
			INSERT INTO [dbo].[transaksiPendaftaranPasienDetail]
						   ([idTransaksiOrderRawatInap]
						   ,[idPendaftaranPasien]
						   ,[idTempatTidur]
						   ,[idStatusPendaftaranRawatInap]
						   ,[tanggalMasuk]
						   ,[tanggalEntry]
						   ,[idUserEntry]
						   ,[keterangan]
						   ,[aktif]
						   ,[idMasterTarifKamar]
						   ,[tarifKamar])
					 VALUES 
						   (@idTransaksiOrderRawatInap
						   ,@idPendaftaranBayi
						   ,@idTempatTidur
						   ,1/*Pendaftaran Normal*/
						   ,@tglDaftar
						   ,GetDate()
						   ,@userIdEntry
						   ,@keterangan
						   ,1/*Aktif*/
						   ,@idMastertarifkamar
						   ,@tarifKamar);

			Commit Tran;
			Select 'Data Pendaftaran Bayi Perinatal Berhasil Disimpan' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END