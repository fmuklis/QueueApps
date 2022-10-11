
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     : Start-X
-- Create date: 20/07/2018
-- Description:	Untuk Edit Pendaftaran Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_editPendaftaranUmum]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idOperator int
    ,@idTempatTidur int
	,@tglDaftar datetime
    ,@userIdEntry int
	--PENANGGUNG JAWAB
	,@namaPenanggungJawabPasien nvarchar(50)
	,@idHubunganKeluargaPenanggungJawab int
	,@alamatPenanggungJawabPasien nvarchar(max)
	,@noHpPenanggungJawab nvarchar(50)
	,@deposit money
	,@keterangan nvarchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@idKelasKamar int;

	SELECT @idRuangan = a.idRuangan, @idmasterTarifKamar = ba.idMasterTarifKamar, @hargaPokok = ba.hargaPokok
		  ,@tarifKamar = ba.tarif, @idKelasKamar = b.idKelas
	  FROM dbo.masterRuangan a
			Inner Join dbo.masterRuanganRawatInap b On a.idRuangan = b.idRuangan
				Inner Join dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
				Inner Join dbo.masterRuanganTempatTidur bb On b.idRuanganRawatInap = bb.idRuanganRawatInap
	 WHERE bb.idTempatTidur = @idTempatTidur;

	SET NOCOUNT ON;
    -- Insert statements for procedure here	
	/*Jika Pasien Belum Dalam Perawatan Rawat Inap*/
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien a
					 INNER JOIN dbo.transaksiOrderRawatInap b On a.idPendaftaranPasien = b.idPendaftaranPasien
			   WHERE b.idStatusOrderRawatInap = 2/*Selesai Admisi*/ AND a.idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			/*Edit Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idRuangan = @idRuangan
				  ,idDokter = @idOperator
				  ,idKelas = @idKelasKamar
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
				  ,depositRawatInap = @deposit
				  ,flagBerkasTidakLengkap = 0
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Edit Data Pendaftaran Rawat Inap*/		
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET idTempatTidur = @idTempatTidur
				  ,tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,idMasterTarifKamar = @idMasterTarifKamar
				  ,tarifKamar = @tarifKamar
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1;

			SELECT 'Data Pendaftaran Rawat Inap Berhasil Diupdate' AS respon, 1 AS responCode;
		End
	/*Jika Diedit Dikelas Yang Sama*/
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien a
						  INNER JOIN dbo.transaksiOrderRawatInap b ON a.idPendaftaranPasien = b.idPendaftaranPasien
					WHERE b.idStatusOrderRawatInap = 3 And a.idPendaftaranPasien = @idPendaftaranPasien AND a.idKelas = @idKelasKamar)
		Begin
			/*Edit Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idRuangan = @idRuangan
				  ,idDokter = @idOperator
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
				  ,depositRawatInap = @deposit
				  ,flagBerkasTidakLengkap = 0
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Edit Data Pendaftaran Rawat Inap*/			
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET idTempatTidur = @idTempatTidur
				  ,tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,idMasterTarifKamar = @idMasterTarifKamar
				  ,tarifKamar = @tarifKamar
				  ,hargaPokok = @hargaPokok
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1;

			Select 'Pendaftaran Rawat Inap Berhasil Diupdate' AS respon, 1 AS responCode;
		End
	Else
		Begin
			/*Edit Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idDokter = @idOperator
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
				  ,depositRawatInap = @deposit
				  ,flagBerkasTidakLengkap = 0
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Edit Data Pendaftaran Rawat Inap*/			
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien And aktif = 1;

			Select 'Pendaftaran Rawat Inap Berhasil Diupdate' As respon, 1 As responCode;
		End
END