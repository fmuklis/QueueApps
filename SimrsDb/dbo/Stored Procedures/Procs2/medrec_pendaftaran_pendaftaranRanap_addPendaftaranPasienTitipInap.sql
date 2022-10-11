
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPendaftaranPasienTitipInap]
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
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
			 WHERE a.idKelas = @idKelasPenjamin;
		END

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Periksa Billing Rawat Jalan
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idpendaftaranPasien
					 AND idStatusPendaftaran >= 5/*Dalam Perawatan RaNap*/ AND idKelasPenjaminPembayaran <> @idKelasPenjamin)
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
			 WHERE idPendaftaranPasien = @idPendaftaranPasien
				   AND aktif = 1/*Recent Bed*/;

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
					   ,@userIdEntry
					   ,@keterangan
					   ,1/*Aktif*/
					   ,@idMastertarifkamar
					   ,@tarifKamar
					   ,@hargaPokok);

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
			Select 'Pendaftaran Pasien Titip Inap Berhasil Disimpan' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END