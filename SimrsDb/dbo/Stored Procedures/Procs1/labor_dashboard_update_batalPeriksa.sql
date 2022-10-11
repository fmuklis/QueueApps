-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_dashboard_update_batalPeriksa]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien int 
		   ,@pasienUMUM bit;
		   
	 SELECT @idPendaftaranPasien = a.idPendaftaranPasien
		   ,@pasienUMUM = CASE
							   WHEN ba.idJenisPenjaminInduk = 1/*UMUM*/
									THEN 1
							   ELSE 0
						   END
	 FROM dbo.transaksiOrder a
		  INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				INNER JOIN dbo.masterJenisPenjaminPembayaranPasien ba ON b.idJenisPenjaminPembayaranPasien = ba.idJenisPenjaminPembayaranPasien
	WHERE a.idOrder = @idOrder;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @pasienUMUM = 1 AND EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader a WHERE a.idOrder = @idOrder AND a.idStatusBayar <> 1/*Menunggu Pembayaran*/)
		BEGIN
			Select 'Tidak Dapat Dibatalkan, Pasien Telah Membayar Biaya Pemeriksaan' AS respon, 0 AS responCode;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
										FROM dbo.farmasiJurnalStok xa
											 INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
											 INNER JOIN dbo.transaksiTindakanPasien xc ON xb.idTindakanPasien = xc.idTindakanPasien
											 INNER JOIN dbo.transaksiOrderDetail xd ON xc.idOrderDetail = xd.idOrderDetail
									   WHERE xd.idOrder = @idOrder) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Stok Akhir BHP Minus Terhadap Koreksi' AS respon, 0 AS responCode;
		END		
	ELSE	
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Koreksi Jurnal Stok*/
			UPDATE a
			   SET a.stokAwal += b.jumlahKeluar
				  ,a.stokAkhir += b.jumlahKeluar
			  FROM dbo.farmasiJurnalStok a
				   OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
								 FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
									  INNER JOIN dbo.transaksiTindakanPasien xc ON xb.idTindakanPasien = xc.idTindakanPasien
									  INNER JOIN dbo.transaksiOrderDetail xd ON xc.idOrderDetail = xd.idOrderDetail
								WHERE xd.idOrder = @idOrder) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idPenjualanDetail = b.idPenjualanDetail
				   INNER JOIN dbo.transaksiTindakanPasien c ON b.idTindakanPasien = c.idTindakanPasien
						INNER JOIN dbo.transaksiOrderDetail ca ON c.idOrderDetail = ca.idOrderDetail
			WHERE ca.idOrder = @idOrder;
				
			/*Mengembalikan Stok BHP*/
			UPDATE a
			   SET a.stok += b.jumlah
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idObatDetail = b.idObatDetail
						INNER JOIN dbo.transaksiTindakanPasien ba ON b.idTindakanPasien = ba.idTindakanPasien
						INNER JOIN dbo.transaksiOrderDetail bb ON ba.idOrderDetail = bb.idOrderDetail
			 WHERE bb.idOrder = @idOrder;

			/*Menghapus Data BHP*/
			DELETE a
			  FROM dbo.farmasiPenjualanDetail a
				   INNER JOIN dbo.transaksiTindakanPasien b ON a.idTindakanPasien = b.idTindakanPasien
						INNER JOIN dbo.transaksiOrderDetail ba ON b.idOrderDetail = ba.idOrderDetail
			 WHERE ba.idOrder = @idOrder;

			/*Update Status Order*/
			UPDATE [dbo].[transaksiOrder]
			   SET idStatusOrder = 1/*Request Pemeriksaan*/
			 WHERE idOrder = @idOrder;

			/*Menghapus Billing Yang Terbuat*/
			DELETE dbo.transaksiBillingHeader
		     WHERE idOrder = @idOrder;

			/*Menghapus Item Request Tambahan*/
			DELETE a
			  FROM dbo.transaksiOrderDetail a
				   Inner Join dbo.transaksiTindakanPasien b On a.idOrderDetail = b.idOrderDetail AND a.idUserEntry = b.idUserEntry
			 WHERE a.idOrder = @idOrder;			 

			/*Menghapus Tindakan Pemeriksaan*/
			DELETE a
			  FROM dbo.transaksiTindakanPasien a
				   INNER JOIN dbo.transaksiOrderDetail b ON a.idOrderDetail = b.idOrderDetail 
			 WHERE b.idOrder = @idOrder;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Pemeriksaan Laboratorium Dibatalkan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, 0 AS responCode;
		END CATCH
END