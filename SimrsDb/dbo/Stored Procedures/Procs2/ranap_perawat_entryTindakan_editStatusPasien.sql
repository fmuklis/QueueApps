-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_editStatusPasien] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int,
	@idStatusPasien int,
	@idUser int,
	@tglKeluarPasien date

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

	IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.transaksiTindakanPasien
				   WHERE idPendaftaranPasien = @idPendaftaranPasien AND idJenisBilling = 6/*Bill Tagihan RaNap*/)
		BEGIN
			Select 'Tidak Dapat Diproses, Tindakan / Perawatan Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.transaksiDiagnosaPasien
						WHERE idPendaftaranPasien = @idPendaftaranPasien)
		BEGIN
			Select 'Tidak Dapat Diproses, Diagnosa Pasien Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*BEGIN*/
			Begin Tran;

			/*UPDATE Status Pendaftaran Pasien*/
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPasien] = @idStatusPasien
				  ,[idStatusPendaftaran] = @idStatusPendaftaran
				  ,[tglKeluarPasien] = CONCAT(@tglKeluarPasien, ' ', CAST(@currentDate AS time(3)))
				  ,[tanggalModifikasi] = @currentDate
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Kalkulasi Biaya Rawat Inap*/
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET tanggalKeluar = CONCAT(@tglKeluarPasien, ' ', CAST(@currentDate AS time(3)))
			 WHERE aktif = 1 AND idPendaftaranPasien = @idPendaftaranPasien;

			/*Create Billing*/
			INSERT INTO [dbo].[transaksiBillingHeader]
					   ([kodeBayar]
					   ,[idPendaftaranPasien]
					   ,[idJenisBilling]
					   ,[idUserEntry])
				 SELECT dbo.noKwitansi()
					   ,a.idPendaftaranPasien
					   ,6/*Bill Tagihan RaNap*/
					   ,@idUser
				   FROM dbo.transaksiPendaftaranPasien a
						INNER JOIN dbo.masterJenisPenjaminPembayaranPasien b ON a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
						LEFT JOIN dbo.transaksiBillingHeader c ON a.idPendaftaranPasien = c.idPendaftaranPasien AND c.idJenisBilling = 6/*Bill Tagihan RaNap*/
				  WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.idJenisPenjaminInduk = 1/*UMUM*/ AND c.idBilling IS NULL;

			/*COMMIT*/
			Commit Tran;
			Select 'Status Pasien Berhasil Diupdate' As respon, 1 As responCode;
		END TRY
		Begin Catch
			/*ROLLBACK*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;			
		End Catch
END