-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderRawatInapPindahKamarInsert]
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
	If Exists(Select 1 From dbo.transaksiOrderRawatInapPindahKamar Where idTransaksiOrderRawatInap = @idTransaksiOrderRawatInap And flagStatus = 0)
		Begin
			/*Respon*/
			Select 'Sudah Ada Permintaan Pindah Kamar Pada Pasien Ini' As respon, 0 As responCode; 
		End
	Else 
		Begin Try
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
		End Try
		Begin Catch
			/*Rollback Commit*/
			Rollback Tran;

			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;			
		End Catch
END