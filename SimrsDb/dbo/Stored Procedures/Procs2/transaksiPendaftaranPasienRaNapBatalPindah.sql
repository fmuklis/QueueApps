-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienRaNapBatalPindah]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiOrderRawatInapPindahKamar a
						 Inner Join dbo.transaksiOrderRawatInap b On a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
				   Where a.flagStatus = 0 And b.idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			/*Respon*/
			Select 'Tidak Ada Permintaan Pindah Kamar Pada Pasien Ini' As respon, 0 As responCode; 
		End
	Else 
		Begin Try
			/*Trans Begin*/
			Begin Tran;

			/*DELETE Menghapus Data Permintaan Pindah Kelas*/
			DELETE a
			  FROM dbo.transaksiOrderRawatInapPindahKamar a
				   Inner Join dbo.transaksiOrderRawatInap b On a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
			 WHERE a.flagStatus = 0 And b.idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Mengembalikan Status Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 5/*Dalam Perawatan Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Tran Commit*/
			Commit Tran;

			/*Respon*/
			Select 'Permintaan Pindah Kamar Dibatalkan, Pasien Kembali Dirawat' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Tran Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END