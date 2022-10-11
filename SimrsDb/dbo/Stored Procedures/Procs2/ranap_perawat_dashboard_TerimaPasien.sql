-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_dashboard_TerimaPasien]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiBillingHeader WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar = 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT TOP 1 'Tidak Dapat Diteruskan, '+ b.namaJenisBilling +' Belum Dibayar' AS respon, 0 AS responCode
			  FROM dbo.transaksiBillingHeader a
				   LEFT JOIN dbo.masterJenisBilling b ON a.idJenisBilling = b.idJenisBilling
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND idStatusBayar = 1/*Menunggu Pembayaran*/;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Update Status Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 5/*Perawatan Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Update Status Request RaNap*/
			UPDATE dbo.transaksiOrderRawatInap
			   SET idStatusOrderRawatInap = 3/*Dalam Perawatan RaNap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Update Jenis Billing Perawatan Sebelumnya Menjadi Ranap*/
			UPDATE a
			   SET a.idJenisBilling = 6/*Billing Rawat Inap*/
			  FROM dbo.transaksiTindakanPasien a
				   LEFT JOIN dbo.transaksiBillingHeader b ON a.idPendaftaranPasien = b.idPendaftaranPasien AND a.idJenisBilling = b.idJenisBilling
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.idBilling IS NULL;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Berhasil Diproses, Pasien Dalam Perawatan Rawat Inap' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END