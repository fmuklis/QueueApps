-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE gizi_layananKonsumsi_RaNap_deleteLayananGizi
	-- Add the parameters for the stored procedure here
	@idLayananGiziPasien int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make variable
	DECLARE @idTempatTidur int;
	
	SELECT @idTempatTidur = idTempatTidur
	  FROM dbo.transaksiPendaftaranPasienDetail
	 WHERE idPendaftaranPasien = @idPendafaranPasien ANd aktif = 1/*true*/;

	IF EXISTS(SELECT 1 FROM dbo.konsumsiPasien 
			   WHERE idPendafaranPasien = @idPendafaranPasien AND idJadwalKonsumsi = @idJadwalKonsumsi
					 AND tanggalKonsumsi = @tanggalKonsumsi)
		BEGIN
			SELECT 'Data layanan gizi pasien telah terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN*/
			DELETE dbo.layananGiziPasien
			 WHERE idLayananGiziPasien = @idLayananGiziPasien;

			SELECT 'Data layanan gizi pasien berhasil disimpan' AS respon, 1 AS responCode;
		--END
END