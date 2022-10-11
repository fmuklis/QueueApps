
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPendaftaranPasienBayiSehatBPJS]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idOperator int
	,@tglDaftar datetime
    ,@userIdEntry int
    ,@keterangan nvarchar(max)
	,@idJenisKelaminPasien int
	,@tglLahirPasien date
	,@namaAyah nvarchar(250)
	,@anakKePasien int
	,@bobotBayi decimal(18,2)
	,@flagBerkasTidakLengkap bit
	,@noBPJS varchar(50)
	,@noSEP varchar(50)

AS
BEGIn
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPasien int
		   ,@idPendaftaranBayi int
		   ,@idTransaksiOrderRawatInap int;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Periksa Billing Rawat Jalan
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
				   ,[idStatusPerkawinanPasien]
				   ,[beratLahir]
				   ,[noBPJS])
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
				   ,@bobotBayi
				   ,@noBPJS
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
					   ,[idHubunganKeluargaPenanggungJawab]
					   ,[noSEPRawatInap]
					   ,[flagBerkasTidakLengkap])
				 SELECT dbo.noRegister()
					   ,@idPasien
					   ,@idPendaftaranPasien
					   ,a.idJenisPendaftaran
					   ,1/*RaNap*/
					   ,@tglDaftar
					   ,a.idAsalPasien
					   ,''
					   ,a.idRuangan
					   ,a.idKelas
					   ,@userIdEntry
					   ,getdate()
					   ,5/*Validasi Kasir Bayar Kartu Jaga*/
					   ,a.idJenisPenjaminPembayaranPasien
					   ,a.idKelasPenjaminPembayaran
					   ,@idOperator
					   ,@namaAyah
					   ,3/*Ayah*/
					   ,@noSEP
					   ,@flagBerkasTidakLengkap
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
					   ,[idUserEntry]
					   ,[keterangan]
					   ,[aktif]
					   ,[idMasterTarifKamar]
					   ,[tarifKamar]
					   ,[ditagih])
				 SELECT @idTransaksiOrderRawatInap
					   ,@idPendaftaranBayi
					   ,a.idTempatTidur
					   ,1/*Pendaftaran Normal*/
					   ,@tglDaftar
					   ,@userIdEntry
					   ,@keterangan
					   ,1/*Aktif*/
					   ,a.idMasterTarifKamar
					   ,a.tarifKamar
					   ,0/*Tidak Ditagih*/
				   FROM dbo.transaksiPendaftaranPasienDetail a
				  WHERE a.idPendaftaranPasien = @idPendaftaranPasien And a.aktif = 1;

			Commit Tran;
			Select 'Data Pendaftaran Bayi Rawat Bersama Berhasil Disimpan' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END