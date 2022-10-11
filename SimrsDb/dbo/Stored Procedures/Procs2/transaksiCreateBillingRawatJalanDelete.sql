-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menghabus Billing Rawat Jalan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiCreateBillingRawatJalanDelete] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaranPasien And tglBayar Is Null And idJenisBayar Is Null And idUserBayar Is Null)
		Begin Try
			Begin Tran transaksiCreateBillingRJalanDel;
			DELETE FROM dbo.transaksiBillingHeader
			 WHERE @idPendaftaranPasien = @idPendaftaranPasien And tglBayar Is Null;

			If Exists (Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)	
				Begin
					UPDATE dbo.transaksiPendaftaranPasien 
					   SET idStatusPendaftaran = 2
					 WHERE idPendaftaranPasien = @idPendaftaranPasien;
					Commit Tran transaksiCreateBillingRJalanDel;
					Select 'Billing Berhasil Dihapus' as respon, 1 as responCode;
				End
			Else
				Begin
					Rollback Tran transaksiCreateBillingRJalanDel;
					Select 'Data Pendaftaran Tidak Ditemukan' as respon, 0 as responCode;
				End				
		End Try
		Begin Catch
			Rollback Tran transaksiCreateBillingRJalanDel;
			Select 'Error ! ' + ERROR_MESSAGE() as respon, 0 as responCode;
		End Catch
	Else
		Begin
			If Exists (Select 1 From dbo.transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaranPasien And tglBayar Is Not Null And idJenisBayar Is Not Null And idUserBayar Is Not Null)
				Begin
					Select 'Billing Telah Dibayar, Tidak Dapat Dibatalkan' as respon, 0 as responCode;
				End
			Else
				Begin
					Select 'Data Billing Tidak Ditemukan' as respon, 0 as responCode;
				End
		End
END