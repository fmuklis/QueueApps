
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     : Start-X
-- Create date: 20/07/2018
-- Description:	Untuk Edit Pendaftaran Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_editPendaftaranTitipInapUmum]
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
	Declare @idRuangan int
		   ,@idKelas int
		   ,@idMasterTarifKamar int
		   ,@tarifKamar money;

	 Select @idMasterTarifKamar = ba.idMasterTarifKamar, @tarifKamar = ba.tarif, @idRuangan = b.idRuangan, @idKelas = b.idKelas
	   From dbo.masterRuanganTempatTidur a
			Inner Join dbo.masterRuanganRawatInap b On a.idRuanganRawatInap = b.idRuanganRawatInap
				Inner Join dbo.masterTarifKamar ba On b.idKelas = ba.idKelas
	  Where a.idTempatTidur = @idTempatTidur;
	SET NOCOUNT ON;
    -- Insert statements for procedure here	
	IF Exists(Select 1 From dbo.transaksiPendaftaranPasien a
					 Inner Join dbo.transaksiOrderRawatInap b On a.idPendaftaranPasien = b.idPendaftaranPasien
			   Where b.idStatusOrderRawatInap = 2 And a.idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			/*Edit Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idRuangan = @idRuangan
				  ,idDokter = @idOperator
				  ,idKelas = @idKelas
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			/*Edit Data Pendaftaran Rawat Inap*/		
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET idTempatTidur = @idTempatTidur
				  ,tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,idMasterTarifKamar = @idMasterTarifKamar
				  ,tarifKamar = @tarifKamar
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien And aktif = 1;
			Select 'Pendaftaran Rawat Inap Berhasil Diupdate' As respon, 1 As responCode;
		End
	Else If Exists(Select 1 From dbo.transaksiPendaftaranPasien a
						  Inner Join dbo.transaksiOrderRawatInap b On a.idPendaftaranPasien = b.idPendaftaranPasien
					Where b.idStatusOrderRawatInap = 3 And a.idPendaftaranPasien = @idPendaftaranPasien And a.idKelas = @idKelas)
		Begin
			/*Edit Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idRuangan = @idRuangan
				  ,idDokter = @idOperator
				  ,namaPenanggungJawabPasien = @namaPenanggungJawabPasien
				  ,idHubunganKeluargaPenanggungJawab = @idHubunganKeluargaPenanggungJawab
				  ,alamatPenanggungJawabPasien = @alamatPenanggungJawabPasien
				  ,noHpPenanggungJawab = @noHpPenanggungJawab
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			/*Edit Data Pendaftaran Rawat Inap*/			
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET idTempatTidur = @idTempatTidur
				  ,tanggalMasuk = @tglDaftar
				  ,idUserEntry = @userIdEntry
				  ,idMasterTarifKamar = @idMasterTarifKamar
				  ,tarifKamar = @tarifKamar
				  ,keterangan = @keterangan
			 WHERE idPendaftaranPasien = @idPendaftaranPasien And aktif = 1;
			Select 'Pendaftaran Rawat Inap Berhasil Diupdate' As respon, 1 As responCode;
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