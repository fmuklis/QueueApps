-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_updatePasienUmum]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@tglDaftarPasien datetime
	,@idRuangan int
	,@idUserEntry int
	,@idAsalPasien int
	,@rujukan bit
	,@idJenisPenjamin int
	,@keterangan nvarchar(max)
	,@idDokterDPJP int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*Jika Pasien Belom Diterima*/
	If Exists(Select 1 From transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idStatusPendaftaran = 1/*Pendaftaran*/)
		Begin
			UPDATE dbo.transaksiPendaftaranPasien
			   SET tglDaftarPasien = @tglDaftarPasien
				  ,idRuangan = @idRuangan
				  ,idUser = @idUserEntry
				  ,idAsalPasien = @idAsalPasien
				  ,rujukan = @rujukan
				  ,idJenisPenjaminPembayaranPasien = @idJenisPenjamin
				  ,keteranganPendaftaran = @keterangan
				  ,idDokter	 = @idDokterDPJP
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			 
			Select 'Data Berhasil Diupdate' as respon, 1 as responCode;				
		End
	Else
		Begin
			UPDATE dbo.transaksiPendaftaranPasien
			   SET tglDaftarPasien = @tglDaftarPasien
				  ,idUser = @idUserEntry
				  ,idAsalPasien = @idAsalPasien
				  ,rujukan = @rujukan
				  ,idJenisPenjaminPembayaranPasien = @idJenisPenjamin
				  ,keteranganPendaftaran = @keterangan
				  ,idDokter = @idDokterDPJP
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			 
			Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
END