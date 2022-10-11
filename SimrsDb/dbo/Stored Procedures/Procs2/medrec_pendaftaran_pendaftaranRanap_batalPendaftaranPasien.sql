-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		takin788
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_batalPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @belumBayar bit = Case
								   When Exists(Select 1 From dbo.transaksiBillingHeader a
												Where a.idJenisBayar Is Null And a.idPendaftaranPasien = @idPendaftaranPasien)
										Then 1
									Else 0
								End
		   ,@pasienUMUMIGD bit = Case
								  When Exists(Select 1 From dbo.transaksiPendaftaranPasien a
													 Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
											   Where a.idJenisPendaftaran = 1/*IGD*/ And b.idJenisPenjaminInduk = 1/*UMUM*/ And a.idPendaftaranPasien = @idPendaftaranPasien)
										Then 1
								  Else 0
							  End
	Declare @idStatusPendaftaran int = Case
											When @belumBayar = 1
												 Then 98/*Buat Billing / Create Billing*/
											When @pasienUMUMIGD = 1
												 Then 3/*Dalam Perawatan IGD*/
											Else 99/*Pulang*/
										End
										
	SET NOCOUNT ON;

    If @belumBayar = 1
		Begin
			Select 'Gagal!: Pasien Belum Membayar '+ namaJenisBilling As respon, 0 As responCode
			  From dbo.transaksiBillingHeader a
				   Inner Join dbo.masterJenisBilling b On a.idJenisBilling = b.idJenisBilling
			 Where a.idJenisBayar Is Null And a.idPendaftaranPasien = @idPendaftaranPasien;
			RETURN;
		End

	If Exists(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrderRawatInap = 1/*Permintaan Rawat Inap*/)
		Begin Try
			Begin Tran tranzRegPasienRaNapBatalRaNap;
				/*UPDATE Data Pendaftaran Pasien*/
				UPDATE a
				   SET a.idStatusPendaftaran = @idStatusPendaftaran
					  ,a.idRuangan = b.idRuanganAsal
					  ,a.idJenisPerawatan = 2/*Rawat Jalan*/
				  FROM dbo.transaksiPendaftaranPasien a
					   Inner Join dbo.transaksiOrderRawatInap b On a.idPendaftaranPasien = b.idPendaftaranPasien
				 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;

				/*UPDATE Data Order Rawat Inap*/
				DELETE dbo.transaksiOrderRawatInap
				 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Commit Tran tranzRegPasienRaNapBatalRaNap;
			If @pasienUMUMIGD = 1
				Begin
					Select 'Berhasil!: Arahkan Petugas IGD Untuk Entry Status Akhir Pasein, Untuk Menyelesaikan Billing Tagihan IGD' As respon, 1 As responCode;
				End
			Else
				Begin
					Select 'Pasien Berhasil Batal Rawat Inap' As respon, 1 As responCode;
				End
		End Try
		Begin Catch
		    Rollback Tran tranzRegPasienRaNapBatalRaNap;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
	Else
		Begin
			Select 'Gagal!: Pasien Telah '+ b.statusOrderRawatInap As respon, 0 As responCode
			  From dbo.transaksiOrderRawatInap a
				   Inner Join dbo.masterStatusOrderRawatInap b On a.idStatusOrderRawatInap = b.idStatusOrderRawatInap
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
	
END