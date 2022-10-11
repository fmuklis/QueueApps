
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Pasien Rawat Jalan (POLI) Yang Direkomen Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_addOrderPasienRanap] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Memastikan Pasien Rajal
	If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idJenisPendaftaran = 1)
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
	Else If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Permintaan Tidak Dapat Diteruskan, Tindakan / Pemeriksaan Belum Dientry' as respon, 0 as responCode;
		End
		--Insert Ke Tabel Order Rawat Inap
	Else If Exists(Select 1 From dbo.transaksiOrderRawatInap where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Permintaan Tidak Dapat Diteruskan, Permintaan Rawat Inap Sudah Ada' as respon, 0 as responCode;			
		End		
	Else
		Begin Try
			Begin Tran;

			/*INSERT Order Rawat Inap*/
			INSERT INTO dbo.transaksiOrderRawatInap
					   ([idPendaftaranPasien]
					   ,[idDokter]
					   ,[idRuanganAsal]
					   ,[tglOrder])
				 SELECT idPendaftaranPasien
					   ,idDokter
					   ,idRuangan
					   ,GETDATE()
				  FROM dbo.transaksiPendaftaranPasien
				 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Status Pendaftaran PX*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 4/*Order Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			
			/*COMMIT Transaksi*/ 		
			Commit Tran;

			/*Respon*/
			Select 'Request Rawat Inap Berhasil' As respon, 1 As responCode;
		End	Try
		Begin Catch
			/*ROLLBACK Transaksi*/
			Rollback Tran;
			
			/*Respon*/
			Select 'Error! :'+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch		
END