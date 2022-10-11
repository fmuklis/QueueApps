-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_deleteTindakanPasien]
	-- Add the parameters for the stored procedure here
	 @idTindakanPasien int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiTindakanPasien a
					 INNER JOIN dbo.transaksiBillingHeader b On a.idPendaftaranPasien = b.idPendaftaranPasien And a.idJenisBilling = b.idJenisBilling
			   WHERE a.idTindakanPasien = @idTindakanPasien AND b.idStatusBayar = 10/*Sudah Dibayar*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Tindakan Telah Dibayar Oleh Pasien' AS respon, 0 AS responCode;
		END
	/*Deteksi Jurnal Stok Minus*/
	ELSE IF EXISTS(SELECT TOP 1 1
					 FROM dbo.farmasiJurnalStok a
						  OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahKeluar
										 FROM dbo.farmasiJurnalStok xa
											  INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
										WHERE xb.idTindakanPasien = @idTindakanPasien) b
					WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail
						  AND a.stokAkhir + b.jumlahKeluar < 0)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, Stok Akhir Minus Terhadap Koreksi' AS respon, 0 AS responCode;
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
				   OUTER APPLY(SELECT xa.idLog, xa.idObatDetail, xa.jumlahMasuk, xa.jumlahKeluar
								 FROM dbo.farmasiJurnalStok xa
									  INNER JOIN dbo.farmasiPenjualanDetail xb ON xa.idPenjualanDetail = xb.idPenjualanDetail
								WHERE xb.idTindakanPasien = @idTindakanPasien) b
			 WHERE a.idLog > b.idLog AND a.idObatDetail = b.idObatDetail

			/*Delete Jurnal Stok*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idPenjualanDetail = b.idPenjualanDetail
			WHERE b.idTindakanPasien = @idTindakanPasien;
				
			/*Mengembalikan Stok BHP*/
			UPDATE a
			   SET a.stok += b.jumlah
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idObatDetail = b.idObatDetail
			 WHERE b.idTindakanPasien = @idTindakanPasien;

			/*Menghapus Data BHP*/
			DELETE dbo.farmasiPenjualanDetail
			 WHERE idTindakanPasien = @idTindakanPasien;

			/*Menghapus Tindakan*/
			DELETE dbo.transaksiTindakanPasien 
			 WHERE idTindakanPasien = @idTindakanPasien;	

			/*Transaction Commit*/
			COMMIT TRAN;		 				
			Select 'Data Tindakan Berhasil Dihapus' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;		 				
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;			
		END CATCH
END