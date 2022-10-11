
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_batalPendaftaranPasienBayi]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int

AS
BEGIn
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Periksa Billing Rawat Jalan
	If Not Exists(Select 1 From dbo.transaksiOrderRawatInap Where idStatusOrderRawatInap = 2/*Selesai Admisi*/ And idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Pendaftaran Bayi Rawat Inap Tidak Dapat Dihapus, Bayi Dalam Perawatan Rawat Inap' As respon, 0 As responCode;
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*DELETE Data Kamar*/
			DELETE dbo.transaksiPendaftaranPasienDetail
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Data Order Rawat Inap*/
			DELETE dbo.transaksiOrderRawatInap
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Data Pasien*/
			DELETE a
			  FROM dbo.masterPasien a
				   Inner Join dbo.transaksiPendaftaranPasien b On a.idPasien = b.idPasien
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			Commit Tran;

			/*Respon*/
			Select 'Data Pasien Bayi Berhasil Dihapus' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			
			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END