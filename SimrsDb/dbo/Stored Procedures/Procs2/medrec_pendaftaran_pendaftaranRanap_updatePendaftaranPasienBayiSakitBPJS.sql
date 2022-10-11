
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     : Start-X
-- Create date: 20/07/2018
-- Description:	Untuk Edit Pendaftaran Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_updatePendaftaranPasienBayiSakitBPJS]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idOperator int
	,@tglDaftar datetime
	--PENANGGUNG JAWAB
	,@namaAyah nvarchar(50)
	,@idJenisKelamin int
	,@tglLahir date
	,@anakKe int
	,@keterangan nvarchar(max)
	,@flagBerkasTidakLengkap bit
	,@bobotBayi decimal(18,2)
	,@noBPJS varchar(50)
	,@noSEP varchar (50)
	,@userIdEntry int
	,@idTempatTidur int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idRuangan int
		   ,@idKelas int
		   ,@idMasterTarifKamar int
		   ,@tarifKamar money;

	 SELECT @idMasterTarifKamar = ba.idMasterTarifKamar, @tarifKamar = ba.tarif, @idRuangan = b.idRuangan, @idKelas = b.idKelas
	   FROM dbo.masterRuanganTempatTidur a
			Inner Join dbo.masterRuanganRawatInap b On a.idRuanganRawatInap = b.idRuanganRawatInap
				Inner Join dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
	  WHERE a.idTempatTidur = @idTempatTidur;

	SET NOCOUNT ON;
    -- Insert statements for procedure here

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
				  ,idKelas = @idKelas
				  ,idKelasPenjaminPembayaran = CASE
													WHEN @idKelas <= 5
														 THEN @idKelas
													ELSE idKelasPenjaminPembayaran
												END
				  ,namaPenanggungJawabPasien = @namaAyah
				  ,idHubunganKeluargaPenanggungJawab = 3/*Ayah*/
				  ,noSEPRawatInap = @noSEP
				  ,keteranganPendaftaran = @keterangan
				  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
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

			SELECT 'Data Pendaftaran Bayi Perinatal Berhasil Diupdate' AS respon, 1 AS responCode;
		END
	ELSE
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien
								 AND (idKelasPenjaminPembayaran = @idKelas OR idKelas = @idKelas))
				BEGIN
					SELECT 'Pasien '+ b.namaKelas +' Tidak Dapat Diubah Ke '+ c.namaKelas +', Lakukan Pindah Ruangan' AS respon, 0 AS responCode
					  FROM dbo.transaksiPendaftaranPasien a
						   LEFT JOIN dbo.masterKelas b ON a.idKelasPenjaminPembayaran = b.idKelas
						   OUTER APPLY (SELECT namaKelas FROM masterKelas WHERE idKelas = @idKelas) c
					  WHERE idPendaftaranPasien = @idPendaftaranPasien;
				END
			ELSE
				BEGIN
					/*Edit Data Pendaftaran*/
					UPDATE dbo.transaksiPendaftaranPasien
					   SET idRuangan = @idRuangan
						  ,idDokter = @idOperator
						  ,idKelas = @idKelas
						  ,namaPenanggungJawabPasien = @namaAyah
						  ,idHubunganKeluargaPenanggungJawab = 3/*Ayah*/
						  ,noSEPRawatInap = @noSEP
						  ,keteranganPendaftaran = @keterangan
						  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
					 WHERE idPendaftaranPasien = @idPendaftaranPasien;

					/*Edit Data Pendaftaran Rawat Inap*/			
					UPDATE dbo.transaksiPendaftaranPasienDetail
					   SET idTempatTidur = @idTempatTidur
						  ,tanggalMasuk = @tglDaftar
						  ,idUserEntry = @userIdEntry
						  ,keterangan = @keterangan
					 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1;

					Select 'Data Pendaftaran Bayi Perinatal Berhasil Diupdate' AS respon, 1 AS responCode;
				END
		END
END