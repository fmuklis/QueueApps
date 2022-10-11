
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Pembatalan Ranap Pasien Rajal
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[operasi_tindakan_entryTindakan_batalOrderPasienRanap] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int = (Select idRuangan From transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Memastikan Paien Rajal
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idJenisPendaftaran = 2 And idStatusPendaftaran < 99)
		Begin Try
			Begin Tran tranzOrdRanapPasienBtl786783264;
			--Hapus Data Di Tabel Order Rawat Inap
			If Exists(Select 1 From dbo.transaksiOrderRawatInap where idPendaftaranPasien = @idPendaftaranPasien)
				Begin
					DELETE FROM [dbo].[transaksiOrderRawatInap]
						  WHERE idPendaftaranPasien = @idPendaftaranPasien;
				End
			--Hapus Billing Yang Sudah Terbuat
			If Exists(Select 1 From dbo.transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaranPasien And idJenisBilling = 1 /*Jenis Billing Rajal*/)
				Begin
					DELETE FROM [dbo].[transaksiBillingHeader]
						  WHERE idPendaftaranPasien = @idPendaftaranPasien And idJenisBilling = 1 /*Jenis Billing Rajal*/;
				End
			--Mengembalikan status perawatan
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 2
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			Commit Tran tranzOrdRanapPasienBtl786783264;
			Select 'Order Rawat Inap Dibatalkan' as respon, 1 as responCode;
		End	Try
		Begin Catch
			Rollback Tran tranzOrdRanapPasienBtl786783264;
			Select 'Error!: ' +ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch	
	Else
		Begin
			Select 'Gagal' As respon, 0 As responCode
		End
END