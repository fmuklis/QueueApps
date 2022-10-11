-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editConvertBpjs] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idStatusPendaftaran = 99/*Pasien Pulang*/)
		Begin
			Select 'Gagal, Pasien Telah Pulang' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE dbo.transaksiPendaftaranPasien 
			   SET idJenisPenjaminPembayaranPasien = 2/*BPJS*/
				  ,flagBerkasTidakLengkap = CASE 
												 WHEN LEN(keteranganPendaftaran) > 2
													  THEN 1
												 ELSE 0
											 END
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			Select 'Penjamin Pasien Berhasil Diubah Ke BPJS' As respon, 1 As responCode;
		End
END