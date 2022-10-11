-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_updatePasienBPJS]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@tglDaftarPasien datetime
	,@idRuangan int
	,@idDokterDPJP int
	,@idUserEntry int
	,@rujukan bit
	,@idAsalPasien int
	,@flagBerkasTidakLengkap bit
	,@keterangan varchar(max)
	,@idJenisPenjamin int
	,@noKartuPenjaminPembayaranPasien varchar(50)
	,@noSEP varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuanganSebelumnya int
		   ,@idjenisPenjaminPembayaranSebelumnya int
		   ,@idKelasPenjaminPembayaranSebelumnya int
		   ,@idJenisPenjaminInduk int;
	Select @idRuanganSebelumnya = a.idRuangan,
		@idjenisPenjaminPembayaranSebelumnya = idJenisPenjaminPembayaranPasien
		,@idKelasPenjaminPembayaranSebelumnya = idKelasPenjaminPembayaran
		 from transaksiPendaftaranPasien a
			where a.idPendaftaranPasien = @idPendaftaranPasien;
		Select @idJenisPenjaminInduk = idJenisPenjaminInduk 
		  From dbo.masterJenisPenjaminPembayaranPasien 
		 Where idJenisPenjaminPembayaranPasien = @idJenisPenjamin;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran = 1/*Pendaftaran*/)
		BEGIN
			/*Update Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET tglDaftarPasien = @tglDaftarPasien
				  ,idRuangan = @idRuangan
				  ,idDokter = @idDokterDPJP
				  ,idUser = @idUserEntry
				  ,rujukan = @rujukan
				  ,idAsalPasien = @idAsalPasien
				  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
				  ,keteranganPendaftaran = @keterangan
				  ,idJenisPenjaminPembayaranPasien = @idJenisPenjamin
				  ,noSEPRawatJalan = @noSEP
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
		END
	ELSE
		BEGIN
			/*Update Data Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET tglDaftarPasien = @tglDaftarPasien
				  ,idDokter = @idDokterDPJP
				  ,idUser = @idUserEntry
				  ,rujukan = @rujukan
				  ,idAsalPasien = @idAsalPasien
				  ,flagBerkasTidakLengkap = @flagBerkasTidakLengkap
				  ,keteranganPendaftaran = @keterangan
				  ,idJenisPenjaminPembayaranPasien = @idJenisPenjamin
				  ,noSEPRawatJalan = @noSEP
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
		END

	/*Update No Penjamin*/
	UPDATE a
	   SET a.noBPJS = @noKartuPenjaminPembayaranPasien
	  FROM dbo.masterPasien a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

	SELECT 'Data Pendaftaran Rawat Jalan Berhasil Diupdate' AS respon, 1 AS responCode;				
END