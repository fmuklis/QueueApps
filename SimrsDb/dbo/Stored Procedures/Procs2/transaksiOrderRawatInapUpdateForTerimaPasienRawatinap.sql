-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderRawatInapUpdateForTerimaPasienRawatinap]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrderRawatInap = 2)
		Begin Try
			Begin Tran tranzRegPasienRaNapUpdOrderRaNap;
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 5/*Perawatan Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			UPDATE dbo.transaksiOrderRawatInap
			   SET idStatusOrderRawatInap = 3
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			UPDATE a
			   SET a.idJenisBilling = 6/*Billing Rawat Inap*/
			  FROM dbo.transaksiTindakanPasien a
				   Left Join dbo.transaksiBillingHeader b On a.idPendaftaranPasien = b.idPendaftaranPasien And a.idJenisBilling = b.idJenisBilling
			 WHERE b.idJenisBayar Is Null And a.idPendaftaranPasien = @idPendaftaranPasien;
			/*DELETE b
			  FROM dbo.transaksiTindakanPasien a
				   Left Join dbo.transaksiBillingHeader b On a.idPendaftaranPasien = b.idPendaftaranPasienAnd a.idJenisBilling = b.idJenisBilling
			 WHERE b.idJenisBayar Is Null And a.idPendaftaranPasien = @idPendaftaranPasien;*/
			Commit Tran tranzRegPasienRaNapUpdOrderRaNap;
			Select 'Pasien Dalam Perawatan Rawat Inap' as respon, 1 as responCode;
		End Try
		Begin Catch
			Rollback Tran tranzRegPasienRaNapUpdOrderRaNap;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END