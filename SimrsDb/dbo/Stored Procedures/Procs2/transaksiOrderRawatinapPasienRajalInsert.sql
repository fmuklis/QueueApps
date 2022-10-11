
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Pasien Rawat Jalan (POLI) Yang Direkomen Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderRawatinapPasienRajalInsert] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int = (Select idRuangan From transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		   ,@pasienBPJS bit = Case
								  When Exists(Select 1 From dbo.transaksiPendaftaranPasien a
													 Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
											   Where idPendaftaranPasien = @idPendaftaranPasien And idJenisPenjaminInduk = 1 /*Pasien UMUM*/)
										Then 0
								  Else 1
							  End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Memastikan Pasien Rajal
	If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idJenisPendaftaran = 2)
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
	Else If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Belum Ada Tindakan Terhadap Pasien Ini' as respon, 0 as responCode;
		End
		--Insert Ke Tabel Order Rawat Inap
	Else If Exists(Select 1 From dbo.transaksiOrderRawatInap where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Pasien Sudah Order Rawat Inap' as respon, 0 as responCode;			
		End		
	Else
		Begin Try
			Begin Tran tranzOrderRaNapPXRajalIns34

			/*INSERT Order Rawat Inap*/
			INSERT INTO dbo.transaksiOrderRawatInap
					   (idPendaftaranPasien
					   ,idRuanganAsal
					   ,idStatusOrderRawatInap
					   ,tglOrder)
				 VALUES (@idPendaftaranPasien
					   ,@idRuangan
					   ,1/*Order Rawat Inap*/
					   ,GetDate());

			/*Create Billing Rawat Jalan Jika Pasien UMUM*/
			If @pasienBPJS = 0
				Begin	
					/*Memastikan Apakah Sudah Ada Billing Yang Sama*/
					If Not Exists(Select 1 From dbo.transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaranPasien And idJenisBilling = 1 /*Jenis Billing Rajall*/)
						Begin
							INSERT INTO dbo.transaksiBillingHeader
									   ([idPendaftaranPasien]
									   ,[kodeBayar]
									   ,[idJenisBilling]
									   ,[idUserEntry]
									   ,[keterangan])
								 VALUES
									   (@idPendaftaranPasien
									   ,dbo.noKwitansi()
									   ,1/*Jenis Billing Rawat Jalan*/
									   ,@idUser
									   ,'Create By Sistem For Order Rawat Inap');
						End
				End

			/*UPDATE Status Pendaftaran PX*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 4/*Order Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			
			/*COMMIT Transaksi*/ 		
			Commit Tran tranzOrderRaNapPXRajalIns34;

			/*Respon*/
			Select 'Order Rawat Inap Berhasil' As respon, 1 As responCode;
		End	Try
		Begin Catch
			/*ROLLBACK Transaksi*/
			Rollback Tran tranzOrderRaNapPXRajalIns34;
			
			/*Respon*/
			Select 'Error! :'+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch		
END