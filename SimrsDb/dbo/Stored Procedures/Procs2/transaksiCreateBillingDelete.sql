CREATE PROCEDURE [dbo].[transaksiCreateBillingDelete]
	 @idBilling int
	,@idPendaftaranPasien int
	
	

as
Begin
	set nocount on;
	If Exists (Select 1 From dbo.transaksiBillingHeader Where idBilling = @idBilling)
		Begin Tran CreateBillingDelete_Tran788991;
			Begin Try
				DELETE FROM [dbo].[transaksiBillingHeader]
				 WHERE idBilling = @idBilling;
					If Exists (Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)	
						Begin

							---Hapus tindakan untuk tarip ruangan
							delete a from transaksiTindakanPasien a 
							inner join masterTarip b on a.idMasterTarif = b.idMasterTarif
							where a.idPendaftaranPasien = @idPendaftaranPasien and b.idJenisTarif = 1;

							UPDATE dbo.transaksiPendaftaranPasien 
							   SET idStatusPendaftaran = 2
							 WHERE idPendaftaranPasien = @idPendaftaranPasien;



							 Commit Tran CreateBillingDelete_Tran788991;
							Select 'Billing Berhasil Dihapus' as respon, 1 as responCode;
						End
					Else
						Begin
							Rollback Tran CreateBillingDelete_Tran788991;
							Select 'Data Pendaftaran Tidak Ditemukan' as respon, 0 as responCode;
						End
				
			End Try
			Begin Catch
				Rollback Tran CreateBillingDelete_Tran788991;

				Select 'ERROR'+ERROR_MESSAGE() as respon, 0 as responCode;
			End Catch
End