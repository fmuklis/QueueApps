-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_convertUMUM]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idJenisPenjaminPembayaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran > 97)
		BEGIN
			SELECT 'Penjamin Tidak Dapat Diubah Keumum, Status Pendaftaran Pasien '+ b.namaStatusPendaftaran AS respon, 0 AS responCode
			  FROM dbo.transaksiPendaftaranPasien a
				   LEFT JOIN dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
		END
	ELSE IF NOT EXISTS(Select 1 From dbo.transaksiPendaftaranPasien 
						Where idPendaftaranPasien = @idPendaftaranPasien AND idJenisPerawatan = 1/*RaNap*/)
		BEGIN
			SELECT 'Penjamin Tidak Dapat Diubah Keumum, Hanya Dapat Convert Pasien Rawat Inap' As respon, 0 As responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*UPDATE Jenis Billing Di tindakan RaJal*/
			UPDATE dbo.transaksiTindakanPasien
			   SET idJenisBilling = 6/*Billing Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Status Penjualan Di Resep Farmasi*/
			UPDATE a
			   SET a.idStatusPenjualan = 2/*Siap Bayar*/
			  FROM dbo.farmasiPenjualanHeader a
				   INNER JOIN dbo.farmasiResep b On a.idResep = b.idResep
				   INNER JOIN dbo.farmasiPenjualanDetail c ON a.idPenjualanHeader = c.idPenjualanHeader
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien AND a.idBilling IS NULL;

			/*Update Penjamin Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien
				  ,[flagBerkasTidakLengkap] = 0/*false*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Update Data Kamar*/
			UPDATE dbo.transaksiPendaftaranPasienDetail
			   SET idStatusPendaftaranRawatInap = 1/*Sesuai Kelas Penjamin*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaranRawatInap <> 2/*Titip Inap*/ ;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Penjamin pembayaran pasien berhasil diubah ke UMUM' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END