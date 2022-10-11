
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPasienBPJS]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idKelasPenjamin int,
	@idOperator int,
    @idTempatTidur int,
	@tglDaftar datetime,
    @userIdEntry int,
	@flagBerkasTidakLengkap bit,
    @keterangan varchar(max),
	--PENANGGUNG JAWAB
	@namaPenanggungJawabPasien varchar(50),
	@idHubunganKeluargaPenanggungJawab int,
	@alamatPenanggungJawabPasien varchar(max),
	@noHpPenanggungJawab varchar(50),
	@deposit money,
	@noBPJS varchar(50),
	@noSEP varchar(50)

AS
BEGIn
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@idKelasKamar int
		   ,@idTransaksiOrderRawatInap int
		   ,@idPasien bigint;
		   
	SELECT @idTransaksiOrderRawatInap = idTransaksiOrderRawatInap, @idPasien = b.idPasien
	  FROM dbo.transaksiOrderRawatInap a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;

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
	ELSE IF EXISTS(SELECT 1 FROM dbo.masterPasien WHERE noBPJS = @noBPJS AND idPasien <> @idPasien)
		BEGIN
			SELECT 'Nomor BPJS Telah Digunakan Pasien: '+ b.namaPasien +' Dengan RM: '+ b.noRM AS respon, 0 AS responCode
			  FROM dbo.masterPasien a
				   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
			 WHERE a.noBPJS = @noBPJS AND a.idPasien <> @idPasien;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*INSERT Data Kamar Rawat Inap*/		
			INSERT INTO dbo.transaksiPendaftaranPasienDetail
					   (idTransaksiOrderRawatInap
					   ,idPendaftaranPasien
					   ,idTempatTidur
					   ,tanggalMasuk
					   ,idUserEntry
					   ,aktif
					   ,idMasterTarifKamar
					   ,tarifKamar)
				 VALUES 
					   (@idTransaksiOrderRawatInap
					   ,@idPendaftaranPasien
					   ,@idTempatTidur
					   ,@tglDaftar
					   ,@userIdEntry
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
				  ,noSEPRawatInap = @noSEP
				  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
				  ,keteranganPendaftaran = @keterangan
			 WHERE idpendaftaranPasien = @idPendaftaranPasien;

			 /*UPDATE DATA BPJS*/
			 UPDATE a
			    SET noBPJS = @noBPJS
			   FROM dbo.masterPasien a
					inner join dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
			  WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Data Permintaan Rawat Inap*/
			UPDATE dbo.transaksiOrderRawatInap
			   SET idStatusOrderRawatInap = 2 /*Selesai Pendaftaran Admisi*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			COMMIT TRAN
			SELECT 'Data Pendaftaran Rawat Inap Berhasil Disimpan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END