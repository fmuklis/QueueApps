CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_addReg]
	@idPasien int,
	@idUser int,
	@rujukan bit,
	@idAsalPasien int,
	@tglDaftarPasien date,
	@keterangan nvarchar(max),
	@idOperator int,
	@idJenisPenjaminPembayaranPasien int,
	@nokartuPenjaminPembayaranPasien nvarchar(50)

As
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idpendaftaranTerakhir int = (Select Max(idPendaftaranPasien) From dbo.transaksiPendaftaranPasien a
												 Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien 
										   Where a.idPasien = @idPasien And b.idJenisPenjaminInduk <> 1)
		   ,@PasienBPJS bit = Case
								   When Exists(Select 1 From dbo.masterJenisPenjaminPembayaranPasien 
												Where idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien And idJenisPenjaminInduk = 2)
										Then 1
								   Else 0
							  End
	DECLARE @tglPendaftaranTerakhir date = Case
												When (Select idJenisPerawatan From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idpendaftaranTerakhir) = 1 --Rawat Inap
													 Then (Select tglKeluarPasien From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idpendaftaranTerakhir)
												Else (Select tglDaftarPasien From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idpendaftaranTerakhir)
										   End
		   ,@currentDate datetime = GETDATE();

	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPasien = @idPasien And idStatusPendaftaran = 7/*Booking RaNap*/)
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*Hapus Data Booking*/
			DELETE a
			  FROM dbo.transaksiOrderRawatInap a
				   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
			 WHERE b.idPasien = @idPasien And b.idStatusPendaftaran = 7/*Booking RaNap*/

			/*Create Billing Jika Pasien UMUM*/
			If @PasienBPJS = 0 And Not Exists(Select 1 From dbo.transaksiBillingHeader a
													 Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
											   Where b.idPasien = @idPasien And b.idStatusPendaftaran = 7/*Booking RaNap*/ And a.idJenisBilling = 1/*Billing RaJal*/)
				Begin
					INSERT INTO [dbo].[transaksiBillingHeader]
							   ([kodeBayar]
							   ,[idPendaftaranPasien]
							   ,[idJenisBilling]
							   ,[idUserEntry])
						 SELECT dbo.noKwitansi()
							   ,a.idPendaftaranPasien
							   ,1/*Billing RaJal*/
							   ,@idUser
						   FROM dbo.transaksiPendaftaranPasien a
						  WHERE a.idPasien = @idPasien And a.idStatusPendaftaran = 7/*Booking RaNap*/;
				End

			/*Update Status Pendaftaran Sebelumnya*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 99/*Pulang*/
				  ,idStatusPasien = 7/*Kontrol RaJal*/
				  ,tglKontrol = @currentDate
			 WHERE idPasien = @idPasien And idStatusPendaftaran = 7/*Booking RaNap*/;

			/*Transaction Commit*/
			Commit Tran;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;

			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch
			
	/*Proses Pendaftaran*/
	If Exists(Select 1 From transaksiPendaftaranPasien Where idPasien = @idPasien And idStatusPendaftaran < 98)
		Begin
			Select 'Pasien Telah Terdaftar Di '+ c.namaRuangan +', Dan Masih Dalam Proses ' + b.namaStatusPendaftaran As respon, 0 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
				   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan
			 Where idPasien = @idPasien And a.idStatusPendaftaran < 98;
		End
	/*Bukan Pasien BPJS*/
	Else If @PasienBPJS <> 1
		Begin
			/*INSERT Entry Data Pendaftaran*/
			INSERT INTO [dbo].[transaksiPendaftaranPasien]
					   ([noReg]
					   ,[idPasien]
					   ,[idJenisPendaftaran]
					   ,[idJenisPerawatan]
					   ,[tglDaftarPasien]
					   --,[jamMasukPasien]
					   ,[rujukan]
					   ,[idAsalPasien]
					   ,[idRuangan]
					   ,[idDokter]
					   ,[idJenisPenjaminPembayaranPasien]
					   ,[idTempatTidur]
					   ,[idUser]
					   ,[tglEntry]
					   ,[idStatusPendaftaran]
					   ,[flagBerkasTidakLengkap])
				 VALUES (dbo.noRegister()
					   ,@idPasien
					   ,1 ---Pendaftaran jenis IGD
					   ,2 ---Dibuat Rawat Jalan Dulu kalau daftar rawat inap di admisi dubah status menjadi 1 (jenis perawatan rawat inap)		
					   ,CONCAT(@tglDaftarPasien, ' ', CAST(@currentDate AS time(3)))
					   --,@currentDate
					   ,@rujukan
					   ,@idAsalPasien
					
					   ,1 ---Ruangan IGD
					   ,@idOperator
					   ,@idJenisPenjaminPembayaranPasien
					   ,13 ---idTempat Tidur non rawat inap
					   ,@idUser
					   ,@currentDate
					   ,1 --Pendaftaran
					   ,0);

			/*Respon*/
			Select 'Data Pendaftaran IGD Berhasil Disimpan' As respon, 1 As responCode, SCOPE_IDENTITY() As idPendaftaranPasien;	    
		End
	Else
		--Pasien BPJS
		Begin
			If Not Exists(Select 1 From dbo.masterPasien Where idPasien	= @idPasien And noBPJS = @nokartuPenjaminPembayaranPasien)
				Begin
					UPDATE dbo.masterPasien
					   SET noBPJS = @nokartuPenjaminPembayaranPasien
					 WHERE idPasien = @idPasien;
				End	
			
			/*INSERT Entry Data Pendaftaran*/
			INSERT INTO [dbo].[transaksiPendaftaranPasien]
					   ([noReg]
					   ,[idPasien]
					   ,[idJenisPendaftaran]
					   ,idJenisPerawatan
					   ,[tglDaftarPasien]
					   --,[jamMasukPasien]
					   ,[rujukan]
					   ,[idAsalPasien]
					   ,idRuangan
					   ,idDokter
					   ,idJenisPenjaminPembayaranPasien
					   ,idTempatTidur
					   ,[idUser]
					   ,[tglEntry]
					   ,[idStatusPendaftaran]
					   ,flagBerkasTidakLengkap)
				 VALUES (dbo.noRegister()
					   ,@idPasien
					   ,1 ---Pendaftaran jenis IGD
					   ,2 ---Dibuat Rawat Jalan Dulu kalau daftar rawat inap di admisi dubah status menjadi 1 (jenis perawatan rawat inap)		
					   ,CONCAT(@tglDaftarPasien, ' ', CAST(@currentDate AS time(3)))
					   --,@currentDate
					   ,@rujukan
					   ,@idAsalPasien
					   ,1 ---Ruangan IGD
					   ,@idOperator
					   ,@idJenisPenjaminPembayaranPasien
					   ,13 ---idTempat Tidur non rawat inap
					   ,@idUser
					   ,@currentDate
					   ,1 --Pendaftaran
					   ,1);
			
			/*Respon*/
			If DATEDIFF(DAY, @tglPendaftaranTerakhir, @currentDate) < 1
				Begin
					Select 'Pendaftarn IGD Berhasil, Pasien Melakukan Pendaftaran 2X Pada Hari Yang Sama' As respon, 0 As responCode;
				End
			Else
				Begin
					Select 'Data Pendaftarn IGD Berhasil Disimpan' As respon, 1 As responCode, SCOPE_IDENTITY() As idPendaftaranPasien;	 
				End 
		End
END