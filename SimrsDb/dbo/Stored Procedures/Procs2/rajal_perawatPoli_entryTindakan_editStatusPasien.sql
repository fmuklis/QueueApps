-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_editStatusPasien] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	,@idStatusPasien int
	,@idUser int
	,@tglKeluarPasien date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idJenisPenjaminInduk int = (Select idJenisPenjaminInduk From dbo.transaksiPendaftaranPasien a
												Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien 
										  Where a.idPendaftaranPasien = @idPendaftaranPasien);
	DECLARE @idStatusPendaftaran int = Case 
											When @idJenisPenjaminInduk = 1/*Pasien UMUM*/
												 Then 98/*Siap Create Billing*/
											Else 99/*Pasien Pulang*/
									   End
		   ,@currentDate datetime = GETDATE();

	--Deteksi Pasien Yang Sedang Order
	IF EXISTS(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Tidak Dapat Disimpan, Pasien Dalam Proses Rawat Inap' As respon, 0 As responCode;
		End
	Else If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Tidak Dapat Disimpan, Tindakan / Perawatan Belum Dientry' As respon, 0 As responCode;
		End				
	Else
		Begin Try
			/*BEGIN*/
			Begin Tran;

			/*UPDATE Status Pendaftaran Pasien*/
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPasien] = @idStatusPasien
				  ,[idStatusPendaftaran] = @idStatusPendaftaran
				  ,[tglKeluarPasien] = CONCAT(@tglKeluarPasien, ' ', CAST(@currentDate AS time(3)))
				  ,[tanggalModifikasi] = @currentDate
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Create Billing*/
			If @idJenisPenjaminInduk = 1/*UMUM*/ And Not Exists(Select 1 From dbo.transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaranPasien And idJenisBilling = 1)
				Begin
					INSERT INTO [dbo].[transaksiBillingHeader]
							   ([kodeBayar]
							   ,[idPendaftaranPasien]
							   ,[idJenisBilling]
							   ,[idUserEntry])
						 VALUES
							   (dbo.noKwitansi()
							   ,@idPendaftaranPasien
							   ,1/*Jenis Billing Perawatan*/
							   ,@idUser);
				End

			/*COMMIT*/
			Commit Tran;
			Select 'Data Berhasil Diupdate' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*ROLLBACK*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;			
		End Catch
END