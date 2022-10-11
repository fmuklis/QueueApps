-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderOKUpdateBatalTerima]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiTindakanPasien a
					 Inner Join dbo.transaksiBillingHeader b On a.idPendaftaranPasien = b.idPendaftaranPasien And a.idJenisBilling = b.idJenisBilling
					 Inner Join dbo.transaksiOrderOK c On a.idTransaksiOrderOK = c.idTransaksiOrderOK
				Where a.idPendaftaranPasien = @idPendaftaranPasien And b.idStatusBayar <> 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, Biaya Operasi Telah Dibayar' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiTindakanPasien a
						  INNER JOIN dbo.farmasiPenjualanDetail b ON a.idTindakanPasien = b.idTindakanPasien
						  INNER JOIN dbo.transaksiOrderOK c On a.idTransaksiOrderOK = c.idTransaksiOrderOK
					WHERE a.idPendaftaranPasien = @idPendaftaranPasien)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, BHP Operasi Telah Dientry' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Order OK*/
			UPDATE [dbo].[transaksiOrderOK]
			   SET [idStatusOrderOK] = 1/*Dalam Proses Order*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Tindakan OK*/
			DELETE a
			  FROM dbo.transaksiTindakanPasien a
				   Inner Join dbo.transaksiOrderOK b On a.idTransaksiOrderOK = b.idTransaksiOrderOK
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;
			
			/*Transaction Commit*/
			Commit Tran;
			Select 'Operasi Batal Dilakukan' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END