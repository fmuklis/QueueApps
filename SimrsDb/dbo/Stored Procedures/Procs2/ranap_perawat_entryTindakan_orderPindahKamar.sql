-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_orderPindahKamar]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int,
	@idUserEntry int,
	@tglOrderPindahKamar date,
	@keterangan nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idTransaksiOrderRawatInap int = (Select idTransaksiOrderRawatInap From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1/*Current Bed*/
						  AND idJenisPelayananRawatInap IS NULL)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Silahkan Entry Jenis Pelayanan Pasien Pada Tab Diagnosa' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiOrderRawatInapPindahKamar WHERE idTransaksiOrderRawatInap = @idTransaksiOrderRawatInap AND flagStatus = 0)
		Begin
			/*Respon*/
			Select 'Sudah Ada Permintaan Pindah Kamar Pada Pasien Ini' AS respon, 0 AS responCode; 
		End
	ELSE 
		BEGIN TRY
			/*Trans Begin*/
			Begin Tran;

			/*INSERT Entry Permintaan Pindah Ruangan*/
			INSERT INTO [dbo].[transaksiOrderRawatInapPindahKamar]
					   ([idTransaksiOrderRawatInap]
					   ,[idUserEntry]
					   ,[tglEntry]
					   ,[tglOrderPindahKamar]
					   ,[keterangan])
				 VALUES
					   (@idTransaksiOrderRawatInap
					   ,@idUserEntry
					   ,GetDate()
					   ,@tglOrderPindahKamar
					   ,@keterangan);
			
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 6/*Permintaan Pindah Kamar*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Trans Commit*/
			Commit Tran;

			/*Respon*/
			Select 'Permintaan Pindah Kamar Berhasil Disimpan' As respon, 1 As responCode;
		END TRY
		BEGIN CATCH
			/*Rollback Commit*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;			
		END CATCH
END