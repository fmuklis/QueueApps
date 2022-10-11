
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Pasien Rawat Jalan (POLI) Yang Direkomen Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_addOrderPasienRanap] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien bigint
	,@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Memastikan Pasien Rajal
	If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idJenisPendaftaran = 2)
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
	Else If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Tindakan / Pemeriksaan Belum Dientry' AS respon, 0 AS responCode;
		End
	Else If Exists(Select 1 From dbo.transaksiOrderRawatInap where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Tidak Dapat Request Rawat Inap, Pasien Telah Terdaftar' as respon, 0 as responCode;			
		End		
	Else
		Begin Try
			Begin Tran;

			/*INSERT Order Rawat Inap*/
			INSERT INTO [dbo].[transaksiOrderRawatInap]
					   ([idPendaftaranPasien]
					   ,[idDokter]
					   ,[idRuanganAsal]
					   ,[idUserEntry])
				 SELECT idPendaftaranPasien
					   ,idDokter
					   ,idRuangan
					   ,@idUser
				   FROM dbo.transaksiPendaftaranPasien
				  WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Create Billing Rawat Jalan Jika Pasien UMUM*/
			IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien a
							 INNER JOIN dbo.masterJenisPenjaminPembayaranPasien b ON a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
							 LEFT JOIN dbo.transaksiBillingHeader c ON a.idPendaftaranPasien = c.idPendaftaranPasien AND c.idJenisBilling = 1/*Bill Tagihan RaJal*/
					   WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.idJenisPenjaminInduk = 1/*UMUM*/ AND c.idBilling IS NULL)
				BEGIN	
					/*Memastikan Apakah Sudah Ada Billing Yang Sama*/
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
				END

			/*UPDATE Status Pendaftaran PX*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 4/*Order Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			
			/*COMMIT Transaksi*/ 		
			Commit Tran;
			Select 'Request Rawat Inap Berhasil' AS respon, 1 AS responCode;
		End	Try
		Begin Catch
			/*ROLLBACK Transaksi*/
			Rollback Tran;
			Select 'Error! :'+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch		
END