-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienBatalRawatJalanUpdate]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Tidak Dapat Dibatalkan, Pasien Telah Diperiksa Dokter' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPendaftaran] = 1/*Pendaftaran*/
			 WHERE [idStatusPendaftaran] = @idPendaftaranPasien;
			Select 'Pasien Berhasil Dibatalkan' as respon, 1 as responCode;
		End
END