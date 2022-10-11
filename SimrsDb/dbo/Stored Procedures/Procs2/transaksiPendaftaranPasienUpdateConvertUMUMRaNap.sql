-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienUpdateConvertUMUMRaNap]
	 @idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisBilling int = Case
									   When Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idJenisPerawatan = 1/*RaNap*/ And idPendaftaranPasien = @idPendaftaranPasien)
											Then 6/*Billing Rawat Inap*/
									   When Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idJenisPerawatan = 2/*RaJal*/ And idJenisPendaftaran = 1/*IGD*/ And idPendaftaranPasien = @idPendaftaranPasien)
											Then 5/*Billing IGD*/
									   Else 1/*Billing Poli Rawat Jalan*/
								   End
	Declare @pasienRaJal bit = Case 
									When @idJenisBilling = 6
										 Then 1
									Else 0
								End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idStatusPendaftaran > = 99 And idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Pasien '+ b.namaStatusPendaftaran As respon, 0 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin Try
			Begin Tran;
			/*UPDATE Penjamin Pasien*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idJenisPenjaminPembayaranPasien = 1/*PRIBADI*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Resep Pasien Menjadi Siap Bayar*/
			UPDATE a
			   SET a.idStatusPenjualan = 2/*Siap Dibayar*/
			  FROM dbo.farmasiPenjualanHeader a
				   Inner Join dbo.farmasiResep b On a.idResep = b.idResep
			 WHERE a.idStatusPenjualan = 3/*Telah Dibayar*/ And b.idPendaftaranPasien = @idPendaftaranPasien;

			/*UPDATE Jenis Billing Tindakan Pasien*/
			UPDATE dbo.transaksiTindakanPasien
			   SET idJenisBilling = 6/*Billing Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			Commit Tran;
			Select 'Berhasil, Penjamin Pembayaran Pasien Berubah Ke UMUM' As respon, 1 As responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END