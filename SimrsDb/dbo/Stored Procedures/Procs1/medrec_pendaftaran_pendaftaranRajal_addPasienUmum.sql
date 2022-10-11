-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addPasienUmum]
	-- Add the parameters for the stored procedure here
	@idPasien int,
	@tglDaftarPasien datetime,
	@idRuangan int,
	@idUser int,
	@rujukan bit,
	@idAsalPasien int,
	@idJenisPenjaminPembayaranPasien int,
	@keterangan nvarchar(max),
	@idDokterDPJP int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idpendaftaranPasien int
		   ,@idTempatTidur int = 13		
		   ,@idPenanggungJawabPasien int
		   ,@cetakKartu int

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
	Else
		Begin
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
					   ,[keteranganPendaftaran]
					   ,[idDokter])
				 VALUES
					   (dbo.noRegister()
					   ,@idPasien
					   ,2 --pendaftaran rawat Jalan
					   ,2 --perawatan rawat jalan
					   ,@tglDaftarPasien
					   ,@rujukan
					   ,@idAsalPasien
					   ,@idRuangan
					   ,@idTempatTidur
					   ,@idUser
					   ,getdate()
					   ,1
					   ,@idJenisPenjaminPembayaranPasien
					   ,99 /*Non Kelas*/
					   ,@keterangan
					   ,@idDokterDPJP);

			/*Get idpendaftaranPasien*/
			Set @idpendaftaranPasien = SCOPE_IDENTITY();

			Select @cetakKartu = cetakKartu From masterPasien Where idPasien = @idPasien;
			
			Select 'Data Berhasil Disimpan' as respon, 1 as responCode, @idpendaftaranPasien as idPendaftaranPasien, @cetakKartu as flagCetakkartu;
		End
END