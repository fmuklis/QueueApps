-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_dashboard_batalPasienDiterima]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran <> 5/*Dlm Perawatan RaNap*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, Pasien Tidak Sedang Dalam Perawatan Rawat Inap / '+ b.deskripsi AS respon, 0 AS responCode
			  FROM dbo.transaksiPendaftaranPasien a
				   LEFT JOIN dbo.masterStatusPendaftaran b ON a.idStatusPendaftaran = b.idStatusPendaftaran
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien; 
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasien = @idPendaftaranPasien
						  GROUP BY idPendaftaranPasien HAVING COUNT(idPendaftaranPasien) > 1)
		BEGIN
			/*Hapus Data Kamar Inap*/
			DELETE dbo.transaksiPendaftaranPasienDetail
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1/*Current Bed*/;

			/*Update Current Bed*/
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET aktif = 1
				  ,tanggalKeluar = NULL
			 WHERE idPendaftaranPasienDetail = (SELECT MAX(idPendaftaranPasienDetail) FROM dbo.transaksiPendaftaranPasienDetail
												 WHERE idPendaftaranPasien = @idPendaftaranPasien);

			/*Update Data Pendaftaran*/
			UPDATE a
			   SET a.idRuangan = bb.idRuangan
				  ,a.idKelas = bb.idKelas
				  ,a.idStatusPendaftaran = 6/*Request Pindah Kamar*/
			  FROM dbo.transaksiPendaftaranPasien a
				   INNER JOIN dbo.transaksiPendaftaranPasienDetail b ON a.idPendaftaranPasien = b.idPendaftaranPasien AND b.aktif = 1/*Current Bed*/
						INNER JOIN dbo.masterRuanganTempatTidur ba ON b.idTempatTidur = ba.idTempatTidur
						INNER JOIN dbo.masterRuanganRawatInap bb ON ba.idRuanganRawatInap = bb.idRuanganRawatInap
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;

			/*Update Status Permintaan RaNap*/
			UPDATE dbo.transaksiOrderRawatInapPindahKamar
			   SET flagStatus = 0
			 WHERE idOrderPindahKamar = (SELECT MAX(idOrderPindahKamar) FROM dbo.transaksiOrderRawatInapPindahKamar a
												INNER JOIN dbo.transaksiOrderRawatInap b ON a.idTransaksiOrderRawatInap = b.idTransaksiOrderRawatInap
										  WHERE b.idPendaftaranPasien = @idPendaftaranPasien);

			SELECT 'Pindah Kamar Rawat Inap Berhasil Dibatalkan, Pasien Dikembalikan Ke '+ kamarInap AS respon, 1 AS responCode
			  FROM dbo.getInfo_dataRawatInap(@idPendaftaranPasien);
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiTindakanPasien a
						  INNER JOIN dbo.farmasiPenjualanDetail b ON a.idTindakanPasien = b.idTindakanPasien
						  INNER JOIN dbo.masterRuangan c ON a.idRuangan = c.idRuangan AND c.idJenisRuangan = 2/*Ins RaNap*/
					WHERE a.idPendaftaranPasien = @idPendaftaranPasien)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, Data Penggunaan BHP Rawat Inap Pasien Tidak Dapat Dihapus' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiResep a
						  INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan AND b.idJenisRuangan = 2/*Ins Rawat Inap*/
					WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idStatusResep = 3/*Resep Selesai*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, Data Resep Rawat Inap Pasien Yang Telah Selesai Tidak Dapat Dihapus' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*DELETE Tindakan Pasien*/
			DELETE a
			  FROM dbo.transaksiTindakanPasien a
				   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan AND b.idJenisRuangan = 2/*Ins Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Order Resep*/
			DELETE a
			  FROM dbo.farmasiResep a
				   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan AND b.idJenisRuangan = 2/*Ins Rawat Inap*/
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
			
			/*DELETE Order Pasien*/
			DELETE a
			  FROM dbo.transaksiOrder a
				   INNER JOIN dbo.masterRuangan b ON a.idRuanganAsal = b.idRuangan AND b.idJenisRuangan = 2/*Ins Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Diagnosa Pasien*/
			DELETE a
			  FROM dbo.transaksiDiagnosaPasien a
				   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan AND b.idJenisRuangan = 2/*Ins Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Status Order Rawat Inap*/
			UPDATE [dbo].[transaksiOrderRawatInap]
			   SET [idStatusOrderRawatInap] = 2/*Selesai Pendaftaran Admisi*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Status Pendaftaran Rawat Inap*/
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET idStatusPendaftaran = 4/*Order RaNap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Billing Tagihan Rawat Jalan Atau IGD*/
			UPDATE a
			   SET idJenisBilling = CASE
										 WHEN b.idJenisRuangan = 1/*Ins IGD*/
											  THEN 6/*Bill Tagihan IGD*/
										 WHEN b.idJenisRuangan = 3/*Ins RaJal*/
											  THEN 1/*Bill Tagihan RaJal*/
										 WHEN b.idJenisRuangan = 4
											  THEN 2/*Bill Tagihan Lab*/
										 WHEN b.idJenisRuangan = 10 
											  THEN 4/*Bill Tagihan Radiologi*/
									 END
			  FROM dbo.transaksiTindakanPasien a
				   INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
				   LEFT JOIN dbo.transaksiBillingHeader c ON a.idJenisBilling = c.idJenisBilling AND a.idPendaftaranPasien = c.idPendaftaranPasien
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND c.idStatusBayar = 1/*Menunggu Pembayaran*/;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Pasien Batal Diterima Rawat Inap, Data Berhasil Diupdate' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END