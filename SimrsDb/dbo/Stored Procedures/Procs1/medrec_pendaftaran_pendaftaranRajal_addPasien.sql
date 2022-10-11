-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_addPasien]
	-- Add the parameters for the stored procedure here
    @nomorBPJS varchar(50),
	@namaLengkapPasien nvarchar(100),
    @gelarDepanPasien nvarchar(50),
    @gelarBelakangPasien nvarchar(50),
    @idPekerjaanPasien int,
    @tempatLahirPasien nvarchar(50),
    @tglLahirPasien date,
    @idJenisKelaminPasien int,
    @alamatPasien nvarchar(250),
    @idDesaKelurahanPasien int,
    @namaAyahPasien nvarchar(50),
    @namaIbuPasien nvarchar(50),
    @anakKePasien int,
    @idDokumenIdentitasPasien int,
    @noDokumenIdentitasPasien nvarchar(50),
    @idPendidikanPasien int,
    @idAgamaPasien int,
    @idWargaNegaraPasien int,
    @noHpPasien1 nvarchar(50),
    @noHPPasien2 nvarchar(50),
    @idStatusPerkawinanPasien int,
	@catatanKesehatan nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @idPasien int;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterPasien 
			   WHERE namaLengkapPasien = @namaLengkapPasien AND tempatLahirPasien = @tempatLahirPasien 
					 AND tglLahirPasien = @tglLahirPasien AND idJenisKelaminPasien = @idJenisKelaminPasien)
		BEGIN
			Select 'Pasien Telah Terdaftar Dengan No RM '+ kodePasien +' , Gunakan No RM Tersebut Untuk Pendaftaran' As respon, 0 As responCode
				From dbo.masterPasien 
				Where namaLengkapPasien = @namaLengkapPasien And tempatLahirPasien = @tempatLahirPasien 
					And tglLahirPasien = @tglLahirPasien And idJenisKelaminPasien = @idJenisKelaminPasien
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.masterPasien WHERE noBPJS = @nomorBPJS) AND LEN(@nomorBPJS) >= 12
		BEGIN
			SELECT 'Nomor BPJS '+ @nomorBPJS +'Terdaftar Dengan No RM '+ kodePasien +' , Gunakan No RM Tersebut Untuk Pendaftaran' As respon, 0 As responCode
		 	  FROM dbo.masterPasien a
			 WHERE a.noBPJS = @nomorBPJS;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.masterPasien WHERE noDokumenIdentitasPasien = @noDokumenIdentitasPasien AND idDokumenIdentitasPasien = 1/*KTP*/)
		BEGIN
			SELECT 'NIK '+ @noDokumenIdentitasPasien +' Telah Terdaftar Dengan No RM '+ kodePasien +' , Gunakan No RM Tersebut Untuk Pendaftaran' As respon, 0 As responCode
		 	  FROM dbo.masterPasien a
			 WHERE noDokumenIdentitasPasien = @noDokumenIdentitasPasien AND idDokumenIdentitasPasien = 1/*KTP*/;
		END
	ELSE 
		BEGIN
			INSERT INTO [dbo].[masterPasien]
					   ([kodePasien]
					   ,[namaLengkapPasien]
					   ,[gelarDepanPasien]
					   ,[gelarBelakangPasien]
					   ,[idPekerjaanPasien]
					   ,[tempatLahirPasien]
					   ,[tglLahirPasien]
					   ,[idJenisKelaminPasien]
					   ,[alamatPasien]
					   ,[idDesaKelurahanPasien]
					   ,[namaAyahPasien]
					   ,[namaIbuPasien]
					   ,[anakKePasien]
					   ,[idDokumenIdentitasPasien]
					   ,[noDokumenIdentitasPasien]
					   ,[idPendidikanPasien]
					   ,[idAgamaPasien]
					   ,[idWargaNegaraPasien]
					   ,[noHpPasien1]
					   ,[noHPPasien2]
					   ,[idStatusPerkawinanPasien]
					   ,[catatanKesehatan]
					   ,[noBPJS])
				 VALUES
					   (dbo.generate_nomorRekamMedis()
					   ,@namaLengkapPasien
					   ,@gelarDepanPasien
					   ,@gelarBelakangPasien
					   ,@idPekerjaanPasien
					   ,@tempatLahirPasien
					   ,@tglLahirPasien
					   ,@idJenisKelaminPasien
					   ,@alamatPasien
					   ,@idDesaKelurahanPasien
					   ,@namaAyahPasien
					   ,@namaIbuPasien
					   ,@anakKePasien
					   ,@idDokumenIdentitasPasien
					   ,@noDokumenIdentitasPasien
					   ,@idPendidikanPasien
					   ,@idAgamaPasien
					   ,@idWargaNegaraPasien
					   ,@noHpPasien1
					   ,@noHPPasien2
					   ,@idStatusPerkawinanPasien
					   ,@catatanKesehatan
					   ,@nomorBPJS);

			SELECT 'Data Pasien Berhasil Disimpan' AS respon, 1 AS responCode, SCOPE_IDENTITY() AS idPasien;
		END
END