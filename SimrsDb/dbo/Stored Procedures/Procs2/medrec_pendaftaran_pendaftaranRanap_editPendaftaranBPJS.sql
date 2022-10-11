
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     : Start-X
-- Create date: 20/07/2018
-- Description:	Untuk Edit Pendaftaran Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_editPendaftaranBPJS]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idOperator int,
	@idTempatTidur int,
	@tglDaftar datetime,
    @userIdEntry int,
	--PENANGGUNG JAWAB
	@namaPenanggungJawabPasien varchar(50),
	@idHubunganKeluargaPenanggungJawab int,
	@alamatPenanggungJawabPasien varchar(max),
	@noHpPenanggungJawab varchar(50),
	@deposit money,
	@flagBerkasTidakLengkap bit,
	@keterangan varchar(max),
	@noSEP varchar(50),
	@noBPJS varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@idKelasKamar int
		   ,@idPasien bigint;

	SELECT @idPasien = a.idPasien
	  FROM dbo.transaksiPendaftaranPasien a
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
	IF EXISTS(SELECT 1 FROM dbo.masterPasien WHERE noBPJS = @noBPJS AND idPasien <> @idPasien)
		BEGIN
			SELECT 'Nomor BPJS Telah Digunakan Pasien: '+ b.namaPasien +' Dengan RM: '+ b.noRM AS respon, 0 AS responCode
			  FROM dbo.masterPasien a
				   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
			 WHERE a.noBPJS = @noBPJS AND a.idPasien <> @idPasien;

			RETURN;
		END	

	/*Edit Data Pasien*/
	UPDATE a
	   SET a.noBPJS = @noBPJS
	  FROM dbo.masterPasien a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

	/*Jika Pasien Belum Diterima*/
	IF Exists(Select 1 From dbo.transaksiPendaftaranPasien a
					 Inner Join dbo.transaksiOrderRawatInap b On a.idPendaftaranPasien = b.idPendaftaranPasien
			   Where b.idStatusOrderRawatInap = 2 And a.idPendaftaranPasien = @idPendaftaranPasien)
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
				  ,noSEPRawatInap = @noSEP
				  ,depositRawatInap = @deposit
				  ,keteranganPendaftaran = @keterangan
				  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Edit Data Pendaftaran Rawat Inap*/		
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET idTempatTidur = @idTempatTidur
				  ,tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,idMasterTarifKamar = @idMasterTarifKamar
				  ,hargaPokok = @hargaPokok
				  ,tarifKamar = @tarifKamar
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1;

			Select 'Pendaftaran Rawat Inap Berhasil Diupdate' AS respon, 1 AS responCode;
		End
	Else If Exists(Select 1 From dbo.transaksiPendaftaranPasien a
						  Inner Join dbo.transaksiOrderRawatInap b On a.idPendaftaranPasien = b.idPendaftaranPasien
					Where b.idStatusOrderRawatInap = 3 And a.idPendaftaranPasien = @idPendaftaranPasien And a.idKelas = @idKelasKamar)
		Begin
			/*Edit Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idRuangan = @idRuangan
				  ,idDokter = @idOperator
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
				  ,noSEPRawatInap = @noSEP
				  ,depositRawatInap = @deposit
				  ,keteranganPendaftaran = @keterangan
				  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Edit Data Pendaftaran Rawat Inap*/			
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET idTempatTidur = @idTempatTidur
				  ,tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,idMasterTarifKamar = @idMasterTarifKamar
				  ,hargaPokok = @hargaPokok
				  ,tarifKamar = @tarifKamar
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien And aktif = 1;

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
				  ,noSEPRawatInap = @noSEP
				  ,depositRawatInap = @deposit
				  ,keteranganPendaftaran = @keterangan
				  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Edit Data Pendaftaran Rawat Inap*/			
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien And aktif = 1;

			Select 'Pendaftaran Rawat Inap Berhasil Diupdate' AS respon, 1 AS responCode;
		End
END