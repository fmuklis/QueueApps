-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_dashboard_batalDiterima]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran <> 3/*Perawatan UGD*/)
		Begin
			Select 'Tidak Dapat Dibatalkan, '+ b.deskripsi AS respon, 0 AS responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b on a.idStatusPendaftaran = b.idStatusPendaftaran
			Where a.idPendaftaranPasien = @idPendaftaranPasien; 
		End
	ELSE IF EXISTS(Select TOP 1 1 From dbo.farmasiResep a
						  Inner Join dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
						  Inner Join dbo.farmasiPenjualanDetail c On b.idPenjualanHeader = c.idPenjualanHeader
					Where a.idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Tidak Dapat Dibatalkan, Resep Pasien Telah Selesai Dan Sedang menunggu Pembayaran' AS respon, 0 AS responCode;
		End
	ELSE IF EXISTS(Select TOP 1 1 From dbo.transaksiBillingHeader a
						  Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
					Where a.idPendaftaranPasien = @idPendaftaranPasien AND a.idStatusBayar <> 1/*Menunggu Pembayaran*/)
		Begin
			Select 'Tidak Dapat Dibatalkan, Pasien Telah Melakukan Pembayaran '+ b.namaJenisBilling AS respon, 0 AS responCode
			  From dbo.transaksiBillingHeader a
				   LEFT JOIN dbo.masterJenisBilling b On a.idJenisBilling = b.idJenisBilling
			 Where a.idPendaftaranPasien = @idPendaftaranPasien And a.idStatusBayar <> 1/*Menunggu Pembayaran*/
		End
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiTindakanPasien a
						  INNER JOIN dbo.farmasiPenjualanDetail b ON a.idTindakanPasien = b.idTindakanPasien
					WHERE a.idPendaftaranPasien = @idPendaftaranPasien)
		BEGIN
			Select 'BHP Pemeriksaan Telah Dientry, Lakukan Pembayaran ' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			Begin Tran;

			/*DELETE Tindakan Pasien*/
			DELETE dbo.transaksiTindakanPasien
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Resep Pasien*/
			DELETE dbo.farmasiResep
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Order Pasien*/
			DELETE dbo.transaksiOrder
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Konsul Pasien*/
			DELETE dbo.transaksiKonsul
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*DELETE Diagnosa Pasien*/
			DELETE dbo.transaksiDiagnosaPasien
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPendaftaran] = 1/*Permintaan Perawatan*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			Commit Tran;
			Select 'Pasien Batal Dirawat, Data Berhasil Diupdate' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END