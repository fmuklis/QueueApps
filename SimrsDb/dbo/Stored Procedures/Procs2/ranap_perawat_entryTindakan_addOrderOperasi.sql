CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_addOrderOperasi]
	-- Add the parameters for the stored procedure here
    @idPendaftaranPasien bigint,
    @tglOrder datetime,
    @idRuanganAsal int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM transaksiOrderOK WHERE idPendaftaranPasien = @idPendaftaranPasien)
		BEGIN
			 SELECT 'Pasien Telah Terdaftar Dalam Request Permintaan Operasi' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1/*Current Bed*/
						  AND idJenisPelayananRawatInap IS NULL)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Silahkan Entry Jenis Pelayanan Pasien Pada Tab Diagnosa' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[transaksiOrderOK]
					   ([idPendaftaranPasien]
					   ,[tglOrder]
					   ,[idRuanganAsal]
					   ,[idStatusOrderOK]
					   ,[idUserEntry]
					   ,[tglEntry])
				 VALUES
					   (@idPendaftaranPasien--int 
					   ,@tglOrder--datetime 
					   ,@idRuanganAsal--int 
					   ,1
					   ,@idUserEntry
					   ,GETDATE());

			SELECT 'Data Request Operasi Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END