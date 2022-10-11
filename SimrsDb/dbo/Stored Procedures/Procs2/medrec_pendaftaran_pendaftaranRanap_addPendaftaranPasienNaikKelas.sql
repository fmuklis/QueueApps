-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_addPendaftaranPasienNaikKelas]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idKelasPenjamin int
	,@idOperator int
    ,@idTempatTidur int
	,@tglDaftar datetime
    ,@idUserEntry int
	,@flagBerkasTidakLengkap bit
    ,@keterangan nvarchar(max)
	,@noBPJS varchar(50)
	,@noSEP varchar (50)
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
	Declare @idMastertarifkamar int
		   ,@hargaPokok money
		   ,@tarifKamar money
		   ,@idRuangan int
		   ,@idKelasKamar int
		   ,@idTransaksiOrderRawatInap int = (Select idTransaksiOrderRawatInap From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien);

	 Select @idRuangan = a.idRuangan, @idmasterTarifKamar = ba.idMasterTarifKamar, @hargaPokok = ba.hargaPokok
		   ,@tarifKamar = ba.tarif, @idKelasKamar = b.idKelas
	   From dbo.masterRuangan a
			Inner Join dbo.masterRuanganRawatInap b On a.idRuangan = b.idRuangan
				Inner Join dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
				Inner Join dbo.masterRuanganTempatTidur bb On b.idRuanganRawatInap = bb.idRuanganRawatInap
	  Where bb.idTempatTidur = @idTempatTidur;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*Edit Data Pasien*/
	UPDATE a
	   SET a.noBPJS = @noBPJS
	  FROM dbo.masterPasien a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien AND ISNULL(a.noBPJS, '') <> @noBPJS;

	BEGIN TRY
		/*Transaction Begin*/
		BEGIN TRAN;

		IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasien = @idpendaftaranPasien)
			Begin
				/*UPDATE Data Kamar Rawat Inap Sebelumnya*/		
				UPDATE dbo.transaksiPendaftaranPasienDetail
				   SET aktif = 0
				 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1;

				/*UPDATE Data Permintaan Pindah Kamar Rawat Inap*/
				UPDATE a
				   SET a.flagStatus = 1/*Sudah Dipindah*/
				  FROM dbo.transaksiOrderRawatInapPindahKamar a
					   Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
				 WHERE b.idPendaftaranPasien = @idPendaftaranPasien AND a.flagStatus = 0;
			End

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
				   ,tarifKamar)
			 VALUES 
				   (@idTransaksiOrderRawatInap
				   ,@idPendaftaranPasien
				   ,3/*Pasien BPJS Naik Kelas*/
				   ,@idTempatTidur
				   ,@tglDaftar
				   ,@idUserEntry
				   ,@keterangan
				   ,1/*Aktif*/
				   ,@idMastertarifkamar
				   ,@tarifKamar);

		/*UPDATE Data Permintaan Rawat Inap*/
		UPDATE dbo.transaksiOrderRawatInap
		   SET idStatusOrderRawatInap = 2 /*Selesai Pendaftaran Admisi*/
		 WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusOrderRawatInap = 1/*Permintaan RaNap*/;

		/*UPDATE Data Pendaftaran Pasien*/
		UPDATE dbo.transaksiPendaftaranPasien 
		   SET idJenisPerawatan = 1/*Rawat Inap*/
			  ,idStatusPendaftaran = 5/*Dalam Perawatan Rawat Inap*/
			  ,idKelasPenjaminPembayaran = @idKelasPenjamin
			  ,idKelas = @idKelasKamar
			  ,idRuangan = @idRuangan
			  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
			  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab 
			  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
			  ,noHpPenanggungJawab = @noHpPenanggungJawab
			  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
			  ,keteranganPendaftaran = @keterangan
			  ,noSEPRawatInap = @noSEP
		 WHERE idPendaftaranPasien = @idPendaftaranPasien;

		/*Transaction Commit*/
		COMMIT TRAN;
		Select 'Pendaftaran Rawat Inap Naik Kelas Berhasil Disimpan' As respon, 1 As responCode;
	END TRY
	BEGIN CATCH
		/*Transaction Rollback*/
		ROLLBACK TRAN;
		Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
	END CATCH
END