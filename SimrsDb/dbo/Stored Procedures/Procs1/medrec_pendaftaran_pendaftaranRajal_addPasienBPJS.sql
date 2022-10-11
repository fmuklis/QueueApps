-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addPasienBPJS]
	-- Add the parameters for the stored procedure here
	 @idPasien int
	,@tglDaftarPasien datetime
	,@idRuangan int
	,@idUser int
	,@idAsalPasien int
	,@idJenisPenjaminPembayaranPasien int
	,@nokartuPenjaminPembayaranPasien nvarchar(50)
	,@noSEP nvarchar(50)
	,@flagBerkasTidakLengkap bit
	,@keterangan nvarchar(max)
	,@idDokterDPJP int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idpendaftaranPasien bigint
		   ,@idTempatTidur int = 13		
		   ,@idPenanggungJawabPasien int
		   ,@cetakKartu int
		   ,@idpendaftaranPasienTerakhir int = (Select Max(idPendaftaranPasien)
												  From dbo.transaksiPendaftaranPasien a
													   Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
												 Where a.idPasien = @idPasien  And b.idJenisPenjaminInduk = 2/*Pasien BPJS*/);
	Declare @tglKunjunganTerakhir date = Case 
											  When Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idpendaftaranPasienTerakhir And idJenisPerawatan = 1 /*Pasien Rawat Inap*/)
												   Then (Select tglKeluarPasien From transaksiPendaftaranPasien Where idPendaftaranPasien = @idpendaftaranPasienTerakhir)
											  Else (Select tglDaftarPasien From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idpendaftaranPasienTerakhir)
										 End
		   ,@pasienBPJS bit = Case
								   When Exists(Select 1 From dbo.masterJenisPenjaminPembayaranPasien Where idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien And idJenisPenjaminInduk = 2/*BPJS*/)
										Then 1
								   Else 0
							  End;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPasien = @idPasien and idStatusPendaftaran < 98)
		Begin
			If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPasien = @idPasien And idStatusPendaftaran = 7/*Boking Ranap*/)
				Begin
					Select 'Pasien Telah Booking Rawat Inap Di Poli '+ c.namaRuangan +' Arahkan Pasien Untuk Menemui Dokter '+ b.NamaOperator  As respon, 0 As responCode
					  From dbo.transaksiPendaftaranPasien a
						   Inner Join dbo.masterOperator b On a.idDokter = b.idOperator
						   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan
					 Where idPasien = @idPasien And a.idStatusPendaftaran = 7/*Boking Ranap*/;	
					 
					 Return;
				End
			Else
				Begin
					Select 'Pasien Telah Terdaftar Di '+ c.namaRuangan +', Dan Masih Dalam Proses ' + b.namaStatusPendaftaran As respon, 0 As responCode
					  From dbo.transaksiPendaftaranPasien a
						   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
						   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan
					 Where idPasien = @idPasien And a.idStatusPendaftaran < 98;

					 Return;
				End
		End
		
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where noSEPRawatJalan = @noSEP) And @noSEP <> '-'
		Begin
			Select 'No SEP Telah Digunakan Pasien Lain' as respon, 0 as responCode;

			Return;
		End

	If @tglKunjunganTerakhir Is Not Null
		Begin
			--Apakah Kunjungan Terakhir Sudah Lebih/Samadengan Tuju Hari
			/*If (Select DATEDIFF(DAY, @tglKunjunganTerakhir, GETDATE()) ) < 7
				Begin
					Select 'Pasien Belum Waktunya Kontrol, Kontrol Selanjutnya Tanggal ' + CAST(DATEADD(DAY, 7, @tglKunjunganTerakhir) As nvarchar(50)) As respon, 0 As responCode;
				End
			Else
				Begin*/
			/* ENTRY / UPDATE Nomor Penjamin*/

			UPDATE [dbo].[masterPasien]
			   SET [noBPJS] = @nokartuPenjaminPembayaranPasien
			 WHERE idPasien = @idPasien

			/*INSERT Data Pendaftaran Pasien*/
			INSERT INTO [dbo].[transaksiPendaftaranPasien]
					   ([noReg]
					   ,[idPasien]
					   ,[idJenisPendaftaran]
					   ,[idJenisPerawatan]
					   ,[tglDaftarPasien]
					   ,[rujukan]
					   ,[idAsalPasien]
					   ,[idRuangan]
					   ,[idTempatTidur]
					   ,[idUser]
					   ,[tglEntry]
					   ,[idStatusPendaftaran]
					   ,[idJenisPenjaminPembayaranPasien]
					   ,[idKelasPenjaminPembayaran]
					   ,[noSEPRawatJalan]
					   ,[flagBerkasTidakLengkap]
					   ,[keteranganPendaftaran]
					   ,[idDokter])
				 VALUES
					   (dbo.noRegister()
					   ,@idPasien
					   ,2 --pendaftaran rawat Jalan
					   ,2 --perawatan rawat jalan
					   ,@tglDaftarPasien
					   ,1/*Rujukan*/
					   ,@idAsalPasien
					   ,@idRuangan
					   ,@idTempatTidur
					   ,@idUser
					   ,getDate()
					   ,1
					   ,@idJenisPenjaminPembayaranPasien
					   ,99 /*Non Kelas*/
					   ,@noSEP
					   ,@flagBerkasTidakLengkap
					   ,@keterangan
					   ,@idDokterDPJP);

			/*Get idpendaftaranPasien*/
			Set @idpendaftaranPasien = SCOPE_IDENTITY();

			Select @cetakKartu = cetakKartu From masterPasien Where idPasien = @idPasien;

			Select 'Data Berhasil Disimpan' as respon, 1 as responCode, @idpendaftaranPasien as idPendaftaranPasien, @cetakKartu as flagCetakkartu;
		End
	/*Pasien BPJS Baru*/
	Else
		Begin
			UPDATE [dbo].[masterPasien]
			   SET [noBPJS] = @nokartuPenjaminPembayaranPasien
			 WHERE idPasien = @idPasien

			/*INSERT Data Pendaftaran Pasien*/
			INSERT INTO [dbo].[transaksiPendaftaranPasien]
					   ([noReg]
					   ,[idPasien]
					   ,[idJenisPendaftaran]
					   ,[idJenisPerawatan]
					   ,[tglDaftarPasien]
					   ,[rujukan]
					   ,[idAsalPasien]
					   ,[idRuangan]
					   ,[idTempatTidur]
					   ,[idUser]
					   ,[tglEntry]
					   ,[idStatusPendaftaran]
					   ,[idJenisPenjaminPembayaranPasien]
					   ,[idKelasPenjaminPembayaran]
					   ,[noSEPRawatJalan]
					   ,[flagBerkasTidakLengkap]
					   ,[keteranganPendaftaran]
					   ,[idDokter])
				 VALUES
					   (dbo.noRegister()
					   ,@idPasien
					   ,2 --pendaftaran rawat Jalan
					   ,2 --perawatan rawat jalan
					   ,@tglDaftarPasien
					   ,1/*Rujukan*/
					   ,@idAsalPasien
					   ,@idRuangan
					   ,@idTempatTidur
					   ,@idUser
					   ,getDate()
					   ,1
					   ,@idJenisPenjaminPembayaranPasien
					   ,99 /*Non Kelas*/
					   ,@noSEP
					   ,@flagBerkasTidakLengkap
					   ,@keterangan
					   ,@idDokterDPJP);

			/*Get idpendaftaranPasien*/
			Set @idpendaftaranPasien = SCOPE_IDENTITY();

			Select @cetakKartu = cetakKartu From masterPasien Where idPasien = @idPasien;
			
			Select 'Data Berhasil Disimpan' as respon, 1 as responCode, @idpendaftaranPasien as idPendaftaranPasien, @cetakKartu as flagCetakkartu;
		End
END