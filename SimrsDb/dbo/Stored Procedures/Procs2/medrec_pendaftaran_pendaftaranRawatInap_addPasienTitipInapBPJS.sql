
-- =============================================
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap Titip Inap
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRawatInap_addPasienTitipInapBPJS]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
    ,@idTempatTidur int
	,@idKelasAsal int
	,@tglDaftar datetime
    ,@idUserEntry int
    ,@keterangan nvarchar(max)
	,@noSEP nvarchar(250)
	--PENANGGUNG JAWAB
	,@namaPenanggungJawabPasien nvarchar(50)
	,@idHubunganKeluargaPenanggungJawab int
	,@alamatPenanggungJawabPasien nvarchar(max)
	,@noHpPenanggungJawab nvarchar(50)
	,@deposit money
	,@biayaKartuJaga money
	,@flagBerkasTidakLengkap bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@idKelasKamar int
		   ,@idTransaksiOrderRawatInap int = (SELECT idTransaksiOrderRawatInap FROM dbo.transaksiOrderRawatInap WHERE idPendaftaranPasien = @idPendaftaranPasien);

	 SELECT @idRuangan = a.idRuangan, @idKelasKamar = a.idKelas, @idmasterTarifKamar = c.idMasterTarifKamar
		   ,@hargaPokok = c.hargaPokok, @tarifKamar = c.tarif
	   FROM dbo.masterRuanganRawatInap a
			INNER JOIN dbo.masterRuanganTempatTidur b On a.idRuanganRawatInap = b.idRuanganRawatInap
			INNER JOIN dbo.masterTarifKamar c ON a.idKelas = c.idKelas
	  WHERE b.idTempatTidur = @idTempatTidur;

	 IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien a
				WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idKelasPenjaminPembayaran > @idKelasKamar)
		BEGIN
			SELECT @idmasterTarifKamar = a.idMasterTarifKamar, @hargaPokok = a.hargaPokok
				  ,@tarifKamar = a.tarif
			  FROM dbo.masterTarifKamar a
			 WHERE a.idKelas = @idKelasAsal;
		END

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Periksa Billing Rawat Jalan
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idpendaftaranPasien
					 AND idStatusPendaftaran >= 5/*Dalam Perawatan RaNap*/ AND idKelasPenjaminPembayaran <> @idKelasAsal)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Penjamin Pasien Tidak Sesuai' AS respon, 0 AS responCode
			  FROM dbo.transaksiPendaftaranPasien a
				   LEFT JOIN dbo.masterKelas b ON a.idKelasPenjaminPembayaran = b.idKelas
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
		END
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*Update Recent Bed*/
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET tanggalKeluar = @tglDaftar
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1/*Recent Bed*/;

			/*Add Data Kamar Rawat Inap*/		
			INSERT INTO dbo.transaksiPendaftaranPasienDetail
					   (idTransaksiOrderRawatInap
					   ,idPendaftaranPasien
					   ,idStatusPendaftaranRawatInap
					   ,idTempatTidur
					   ,tanggalMasuk
					   ,idUserEntry
					   ,keterangan
					   ,aktif
					   ,idMasterTarifKamar
					   ,tarifKamar
					   ,hargaPokok)
				 VALUES 
					   (@idTransaksiOrderRawatInap
					   ,@idPendaftaranPasien
					   ,2/*Pasien Titip Kamar Rawat Inap*/
					   ,@idTempatTidur
					   ,@tglDaftar
					   ,@idUserEntry
					   ,@keterangan
					   ,1/*Aktif*/
					   ,@idMastertarifkamar
					   ,@tarifKamar
					   ,@hargaPokok);

			/*UPDATE Data Pendaftaran Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien 
			   SET idJenisPerawatan = 1/*Rawat Inap*/
			      ,idKelasPenjaminPembayaran = @idKelasAsal
				  ,idKelas = @idKelasKamar
				  ,idRuangan = @idRuangan
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab 
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
				  ,depositRawatInap = @deposit
				  ,idStatusPendaftaran = CASE
											  WHEN idStatusPendaftaran = 4
												   THEN idStatusPendaftaran
											  ELSE 5/*Dalam Perawatan RaNap*/
										  END
			 WHERE idpendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Data Permintaan Rawat Inap*/
			UPDATE dbo.transaksiOrderRawatInap
			   SET idStatusOrderRawatInap = 2 /*Selesai Pendaftaran Admisi*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusOrderRawatInap = 1/*Request RaNap*/;

			/*Update Status Request Pindah Kamar*/
			UPDATE a
			   SET a.flagStatus = 1/*Telah Dipindah*/
			  FROM dbo.transaksiOrderRawatInapPindahKamar a
				   INNER JOIN dbo.transaksiOrderRawatInap b ON a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien AND a.flagStatus = 0;

			/*Transaction Commit*/
			Commit Tran;

			IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader WHERE idPendaftaranPasien = @idPendaftaranPasien
							 AND idStatusBayar = 1/*Menunggu Pembayaran*/)
				BEGIN
					SELECT TOP 1 'Pendaftaran Titip Inap Berhasil, Arahkan Penanggung Jawab Pasien Untuk Menyelesaikan Pembayaran'+ b.namaJenisBilling AS respon, 0 AS responCode
					  FROM dbo.transaksiBillingHeader a
						   LEFT JOIN dbo.masterJenisBilling b ON a.idJenisBilling = b.idJenisBilling
					 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar = 1/*Menunggu Pembayaran*/
				END
			ELSE
				BEGIN
					SELECT 'Pendaftaran Pasien Titip Inap Berhasil Disimpan' AS respon, 1 AS responCode;
				END
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END