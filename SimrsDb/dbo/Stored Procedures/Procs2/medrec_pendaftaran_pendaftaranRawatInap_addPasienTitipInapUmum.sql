
-- =============================================
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap Titip Inap
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRawatInap_addPasienTitipInapUmum]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
    ,@idTempatTidur int
	,@idKelasAsal int
	,@tglDaftar datetime
    ,@idUserEntry int
    ,@keterangan nvarchar(max)
	--PENANGGUNG JAWAB
	,@namaPenanggungJawabPasien nvarchar(50)
	,@idHubunganKeluargaPenanggungJawab int
	,@alamatPenanggungJawabPasien nvarchar(max)
	,@noHpPenanggungJawab nvarchar(50)
	,@deposit money
	,@biayaKartuJaga money

AS
BEGIn
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@pasienRawatJalan bit = Case
										When Exists(Select 1 From dbo.transaksiPendaftaranPasien a 
														   Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
													 Where a.idPendaftaranPasien = @idPendaftaranPasien And b.idJenisPenjaminInduk = 1/* Pasien UMUM */ And a.idJenisPendaftaran = 1 /*Pasien Rawat Jalan*/)
											Then 1
										Else 0
									End
		   ,@idStatusPendaftaran int = Case
											When Exists(Select 1 From dbo.transaksiPendaftaranPasien 
														 Where idStatusPendaftaran >=4 And idPendaftaranPasien = @idPendaftaranPasien)
												 Then (Select idStatusPendaftaran From dbo.transaksiPendaftaranPasien 
														Where idPendaftaranPasien = @idPendaftaranPasien)
											Else 4/*Order Rawat Inap*/
										End;
		Select @idMastertarifkamar = a.idMasterTarifKamar, @hargaPokok = a.hargaPokok, @tarifKamar = a.tarif
		  From dbo.masterTarifKamar a
		 Where a.idKelas = @idKelasAsal;

		Select @idRuangan = a.idRuangan
		  From dbo.masterRuangan a
			   Inner Join masterRuanganRawatInap b on a.idRuangan = b.idRuangan				
			   Inner Join masterRuanganTempatTidur c on b.idRuanganRawatInap = c.idRuanganRawatInap
		 Where c.idTempatTidur = @idTempatTidur;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If @pasienRawatJalan = 1 And Exists(Select 1 From dbo.transaksiBillingHeader 
										 Where idPendaftaranPasien = @idPendaftaranPasien And idJenisBayar Is Null)
		Begin
			Select 'Gagal!: Billing '+ b.namaJenisBilling +' Belum Dibayar' As respon, 0 As responCode
			  From dbo.transaksiBillingHeader a
				   Inner Join dbo.masterJenisBilling b On a.idJenisBilling = b.idJenisBilling
			 Where a.idPendaftaranPasien = @idPendaftaranPasien And a.idJenisBayar Is Null;
		End
	Else
		Begin	
			IF Not Exists (Select 1 From dbo.[transaksiPendaftaranPasienDetail] 
							Where [idPendaftaranPasien] = @idpendaftaranPasien And aktif = 1)
				Begin Try
					Begin Tran insertRawatInapTitipKamar7882992;			
					INSERT INTO [dbo].[transaksiPendaftaranPasienDetail]
							   ([idPendaftaranPasien]
							   ,[idStatusPendaftaranRawatInap]
							   ,[idTempatTidur]
							   ,[tanggalMasuk]
							   ,[tanggalEntry]
							   ,[idUserEntry]
							   ,[keterangan]
							   ,[aktif]
							   ,[idMasterTarifKamar]
							   ,[hargaPokok]
							   ,[tarifKamar])
						 VALUES (@idPendaftaranPasien
							   ,2/*Titip Kamar Inap*/
							   ,@idTempatTidur
							   ,@tglDaftar
							   ,GETDATE()
							   ,@idUserEntry
							   ,@keterangan
							   ,1
							   ,@idMastertarifkamar
							   ,@hargaPokok
							   ,@tarifKamar
							   )
				   UPDATE dbo.transaksiPendaftaranPasien 
					  SET idJenisPerawatan = 1
						 ,idRuangan = @idRuangan
						 ,idKelas = @idKelasAsal
						 ,idKelasPenjaminPembayaran = @idKelasAsal
						 ,idStatusPendaftaran = @idStatusPendaftaran
						 ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
						 ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab
						 ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
						 ,noHpPenanggungJawab = @noHpPenanggungJawab
						 ,keteranganPendaftaran = @keterangan
						 ,depositRawatInap = @deposit
						 ,depositKartuJaga = @biayaKartuJaga
					WHERE idpendaftaranPasien = @idPendaftaranPasien;

					UPDATE dbo.transaksiOrderRawatInap
					   SET idStatusOrderRawatInap = 2 --Selesai Pendaftaran Admisi
					 WHERE idPendaftaranPasien = @idPendaftaranPasien;
					Commit Tran insertRawatInapTitipKamar7882992;
					Select 'Data Berhasil Disimpan' as respon, 1 as responCode;
				End Try
				Begin Catch
					Rollback Tran insertRawatInapTitipKamar7882992;
					select 'Error!: ' + ERROR_MESSAGE() as respon, 0 as responCode;
				End Catch
			ELSE
				Begin
					Select 'Maaf Pasien Telah Terdaftar Di ' + c.namaRuanganRawatInap As respon, 0 As responCode
					  From dbo.transaksiPendaftaranPasienDetail a
						   Inner Join dbo.masterRuanganTempatTidur b On a.idTempatTidur = b.idTempatTidur
						   Inner Join dbo.masterRuanganRawatInap c on b.idRuanganRawatInap = c.idRuanganRawatInap
					 Where a.idPendaftaranPasien = @idPendaftaranPasien And a.aktif = 1;
				End
		End
END