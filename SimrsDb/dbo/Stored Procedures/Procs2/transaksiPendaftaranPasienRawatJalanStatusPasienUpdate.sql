-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienRawatJalanStatusPasienUpdate] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	,@idStatusPasien int
	,@idUser int
	,@tglKontrol date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisPenjaminInduk int = (Select idJenisPenjaminInduk From dbo.transaksiPendaftaranPasien a
												Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien 
										  Where a.idPendaftaranPasien = @idPendaftaranPasien);
	Declare @idStatusPendaftaran int = Case 
											When @idJenisPenjaminInduk = 1/*Pasien UMUM*/
												 Then 98/*Siap Create Billing*/
											Else 99/*Pasien Pulang*/
									   End;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Deteksi Pasien Yang Sedang Order
	If Exists(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Pasien Dalam Proses Rawat Inap' As respon, 0 As responCode;
		End
	Else If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Belum Ada Tindakan Terhadap Pasien Ini' As respon, 0 As responCode;
		End
	/*Else If Exists(Select 1 From dbo.transaksiKonsul Where idPendaftaranPasien = @idPendaftaranPasien And idStatusKonsul <> 3)
		Begin
			Select 'Tidak Dapat Disimpan, Ada Proses Konsul Yang Belum Selesai' As respon, 0 As responCode;
		End	*/					
	Else
		Begin Try
			/*BEGIN*/
			Begin Tran tranzRegRaJalStatusPXUpdate;

			/*UPDATE Status Pendaftaran Pasien*/
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPasien] = @idStatusPasien
				  ,[idStatusPendaftaran] = @idStatusPendaftaran
				  ,[tglKontrol] = @tglKontrol
				  ,tglKeluarPasien = GetDate()
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
			Commit Tran tranzRegRaJalStatusPXUpdate;
			
			/*Respon*/
			Select 'Data Berhasil Diupdate' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*ROLLBACK*/
			Rollback Tran tranzRegRaJalStatusPXUpdate;
			
			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;			
		End Catch
END