-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_editBPJS]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int,	
	@tglDaftar datetime,
	@idDokter int,
	@rujukan bit,
	@idAsalPasien int,
	@flagBerkasTidakLengkap bit,
	@keterangan varchar(max),
	@idJenisPenjamin int,
	@noPenjamin varchar(50),
	@SEP varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*Jika Pasien Belum Diterima*/
	/*If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idStatusPendaftaran <= 3)
		Begin*/
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [tglDaftarPasien] = @tglDaftar
				  ,[idDokter] = @idDokter
				  ,[rujukan] = @rujukan
				  ,[flagBerkasTidakLengkap] = @flagBerkasTidakLengkap
				  ,[keteranganPendaftaran] = @keterangan
				  ,[idAsalPasien] = @idAsalPasien
				  ,[idJenisPenjaminPembayaranPasien] = @idJenisPenjamin
				  ,[noSEPRawatJalan] = @SEP
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			
			UPDATE a
			   SET a.noBPJS = @noPenjamin
			  FROM dbo.masterPasien a
				   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPasien = b.idPasien
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

			Select 'Data Pendaftaran Pasien Berhasil Diupdate' As respon, 1 As responCode;
		/*End
	Else
		Begin
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [tglDaftarPasien] = @tglDaftar
				  ,[rujukan] = @rujukan
				  ,[idAsalPasien] = @idAsalPasien
				  ,[flagBerkasTidakLengkap] = @flagBerkasTidakLengkap
				  ,[keterangan] = @keterangan
				  ,[noSEPRawatJalan] = @SEP
			 WHERE idPendaftaranPasien=@idPendaftaranPasien;

			Select 'Data Pendaftaran Pasien Berhasil Diupdate' As respon, 1 As responCode;
		End*/
END