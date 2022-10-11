-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_convertBPJS]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idJenisPenjaminPembayaranPasien int,
	@idKelasPenjamin int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran > 97)
		BEGIN
			Select 'Penjamin Tidak Dapat Diubah Keumum, Status Pendaftaran Pasien '+ b.namaStatusPendaftaran AS respon, 0 AS responCode
			  From dbo.transaksiPendaftaranPasien a
				   LEFT JOIN dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 Where idPendaftaranPasien = @idPendaftaranPasien;
		END
	ELSE IF NOT EXISTS(Select 1 From dbo.transaksiPendaftaranPasien 
						Where idPendaftaranPasien = @idPendaftaranPasien AND idJenisPerawatan = 1/*RaNap*/)
		Begin
			Select 'Penjamin Tidak Dapat Diubah Keumum, Hanya Dapat Convert Pasien Rawat Inap' As respon, 0 As responCode;
		End
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Jenis Billing Di tindakan RaNap*/
			UPDATE dbo.transaksiTindakanPasien
			   SET idJenisBilling = 6/*Billing Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Status Penjualan Di Resep Farmasi*/
			UPDATE a
			   SET a.idStatusPenjualan = 2/*Siap Bayar*/
			  FROM dbo.farmasiPenjualanHeader a
				   INNER JOIN dbo.farmasiResep b ON a.idResep = b.idResep
			 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

			/*Update Penjamin Pendaftaran*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idJenisPenjaminPembayaranPasien = @idJenisPenjaminPembayaranPasien
				  ,idKelasPenjaminPembayaran = @idKelasPenjamin
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Update Data Kamar Pasien*/
			UPDATE a
			   SET idStatusPendaftaranRawatInap = 3/*Naik Kelas*/
			  FROM dbo.transaksiPendaftaranPasienDetail a
				   INNER JOIN dbo.masterTarifKamar b ON a.idMasterTarifKamar = b.idMasterTarifKamar
			 WHERE idPendaftaranPasien = @idPendaftaranPasien AND b.idKelas < @idKelasPenjamin AND a.idStatusPendaftaranRawatInap <> 2/*Titip Kamar*/;

			/*Transaction Commit*/
			Commit Tran;
			Select 'Penjamin Pembayaran Pasien Berhasil Diubah Ke BPJS' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END
select * from dbo.masterJenisBilling