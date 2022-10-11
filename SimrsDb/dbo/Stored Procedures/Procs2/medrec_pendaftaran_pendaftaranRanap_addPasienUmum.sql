
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPasienUmum]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idKelasPenjamin int
	,@idOperator int
    ,@idTempatTidur int
	,@tglDaftar datetime
    ,@userIdEntry int
    ,@keterangan nvarchar(max)
	--PENANGGUNG JAWAB
	,@namaPenanggungJawabPasien nvarchar(50)
	,@idHubunganKeluargaPenanggungJawab int
	,@alamatPenanggungJawabPasien nvarchar(max)
	,@noHpPenanggungJawab nvarchar(50)
	,@deposit money

AS
BEGIn
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@idKelasKamar int
		   ,@idTransaksiOrderRawatInap int = (Select idTransaksiOrderRawatInap From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien);

	SELECT @idRuangan = a.idRuangan, @idmasterTarifKamar = ba.idMasterTarifKamar, @hargaPokok = ba.hargaPokok
		  ,@tarifKamar = ba.tarif, @idKelasKamar = b.idKelas
	  FROM dbo.masterRuangan a
			Inner Join dbo.masterRuanganRawatInap b On a.idRuangan = b.idRuangan
				Inner Join dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
				Inner Join dbo.masterRuanganTempatTidur bb On b.idRuanganRawatInap = bb.idRuanganRawatInap
	 WHERE bb.idTempatTidur = @idTempatTidur;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Periksa Billing Rawat Jalan
	IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasien = @idpendaftaranPasien)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Pasien Telah Terdaftar Dalam Perawatan Rawat Inap' AS respon, 0 AS responCode;
		END
	ELSE
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*INSERT Data Kamar Rawat Inap*/		
			INSERT INTO dbo.transaksiPendaftaranPasienDetail
					   (idTransaksiOrderRawatInap
					   ,idPendaftaranPasien
					   ,idTempatTidur
					   ,tanggalMasuk
					   ,tanggalEntry
					   ,idUserEntry
					   ,keterangan
					   ,aktif
					   ,idMasterTarifKamar
					   ,tarifKamar)
				 VALUES 
					   (@idTransaksiOrderRawatInap
					   ,@idPendaftaranPasien
					   ,@idTempatTidur
					   ,@tglDaftar
					   ,GetDate()
					   ,@userIdEntry
					   ,@keterangan
					   ,1/*Aktif*/
					   ,@idMastertarifkamar
					   ,@tarifKamar);

			/*UPDATE Data Pendaftaran Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien 
			   SET idJenisPerawatan = 1/*Rawat Inap*/
			      ,idKelasPenjaminPembayaran = @idKelasPenjamin
				  ,idKelas = @idKelasKamar
				  ,idRuangan = @idRuangan
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab 
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
				  ,depositRawatInap = @deposit
			 WHERE idpendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Data Permintaan Rawat Inap*/
			UPDATE dbo.transaksiOrderRawatInap
			   SET idStatusOrderRawatInap = 2 /*Selesai Pendaftaran Admisi*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			Commit Tran;

			IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idPendaftaranPasien = @idPendaftaranPasien
							 AND idStatusBayar = 1/*Menunggu Pembayaran*/)
				BEGIN
					SELECT TOP 1 'Pendaftaran Rawat Inap Berhasil, Arahkan Penanggung Jawab Pasien Untuk Menyelesaikan Pembayaran'+ b.namaJenisBilling AS respon, 1 AS responCode
					  FROM dbo.transaksiBillingHeader a
						   LEFT JOIN dbo.masterJenisBilling b ON a.idJenisBilling = b.idJenisBilling
					 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar = 1/*Menunggu Pembayaran*/
				END
			ELSE
				BEGIN
					SELECT 'Pendaftaran Pasien Rawat Inap Berhasil Disimpan' AS respon, 1 AS responCode;
				END
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END