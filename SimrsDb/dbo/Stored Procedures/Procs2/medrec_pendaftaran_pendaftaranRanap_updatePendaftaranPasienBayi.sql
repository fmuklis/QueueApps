
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     : Start-X
-- Create date: 20/07/2018
-- Description:	Untuk Edit Pendaftaran Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_updatePendaftaranPasienBayi]
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
	,@bobotBayi decimal(18,2)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here	
	/*UPDATE Data pasien*/
	UPDATE a
	   SET a.namaAyahPasien = @namaAyah
		  ,a.idJenisKelaminPasien = @idJenisKelamin
		  ,a.tglLahirPasien = @tglLahir
		  ,a.anakKePasien = @anakKe
		  ,a.beratLahir = @bobotBayi
	  FROM dbo.masterPasien a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPasien = b.idPasien
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

	 /*UPDATE Data Pendaftaran Bayi*/
	 UPDATE dbo.transaksiPendaftaranPasien
	    SET tglDaftarPasien = @tglDaftar
		   ,idDokter = @idOperator
	  WHERE idPendaftaranPasien = @idPendaftaranPasien;

	 /*UPDATE Data Pendaftaran Kamar Bayi*/
	 UPDATE dbo.transaksiPendaftaranPasienDetail
	    SET tanggalMasuk = @tglDaftar
		   ,keterangan = @keterangan
	  WHERE idPendaftaranPasien = @idPendaftaranPasien;

	Select 'Data Pendaftaran Rawat Inap Bayi Berhasil Diupdate' As respon, 1 As responCode;
END