-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editConvertUmum] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran = 99/*Pasien Pulang*/)
		BEGIN
			SELECT 'Tidak Dapat Diubah, Pasien Telah Pulang' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE dbo.transaksiPendaftaranPasien 
			   SET idJenisPenjaminPembayaranPasien = 1/*Pribadi*/
				  ,flagBerkasTidakLengkap = 0
				  ,keteranganPendaftaran = NULL
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			SELECT 'Penjamin Pasien Berhasil Diubah Ke UMUM' AS respon, 1 AS responCode;
		END
END