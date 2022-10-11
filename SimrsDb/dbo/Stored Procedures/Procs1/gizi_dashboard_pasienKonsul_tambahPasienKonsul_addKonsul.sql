-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[gizi_dashboard_pasienKonsul_tambahPasienKonsul_addKonsul]
	-- Add the parameters for the stored procedure here
	 @idUserEntry int
	,@idPendaftaranPasien int
	,@tglOrderKonsul datetime
	,@alasanKonsul nvarchar(max)
	,@konsulYangDiminta nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idRuanganAsal int = (Select idRuangan From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien),
			@idRuanganTujuan int = 61 /*poli gizi*/;
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	IF NOT EXISTS (SELECT 1 FROM dbo.transaksiPendaftaranPasien
					   WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran BETWEEN 2 AND 7)
		BEGIN
			Select 'Pasien tidak dalam pelayanan atau sudah pulang' As respon, 0 As responCode;
		END

	ELSE IF EXISTS (Select 1 From dbo.transaksiKonsul Where idPendaftaranPasien = @idPendaftaranPasien And idRuanganTujuan = @idRuanganTujuan And idStatusKonsul = 2)
		BEGIN
			Select 'Pasien Sudah Dalam Pemeriksaan Dokter Konsul' As respon, 0 As responCode;
		END
	
	ELSE IF Not Exists (Select 1 From dbo.transaksiKonsul Where idPendaftaranPasien = @idPendaftaranPasien And idRuanganTujuan = @idRuanganTujuan And idStatusKonsul = 1)
		Begin
			INSERT INTO dbo.transaksiKonsul
					   (idPendaftaranPasien
					   ,idRuanganAsal
					   ,idRuanganTujuan
					   ,tglOrderKonsul
					   ,idStatusKonsul
					   ,idUserEntry
					   ,alasan
					   ,itemKonsul)
				 VALUES
					   (@idPendaftaranPasien
					   ,@idRuanganAsal
					   ,@idRuanganTujuan
					   ,@tglOrderKonsul
					   ,2 /*Dalam Pemeriksaan*/
					   ,@idUserEntry
					   ,@alasanKonsul
					   ,@konsulYangDiminta);
			Select 'Data Pasien Konsul Berhasil Ditambahkan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Sudah Ada Permintaan Konsul Yang Sama Belum Diproses' As respon, 0 As responCode;
		End
END