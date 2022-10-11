-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		takin788
-- Create date: 20/07/2018
-- Description:	untuk pendaftaranRawatInap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_batalAdmisiPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	If Exists(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrderRawatInap = 2/*Selesai Admisi*/)
		Begin Try
			Begin Tran tranzRegPasienRaNapBatalAdmisi;
				/*DELETE Data Kamar Pasien*/
				DELETE dbo.transaksiPendaftaranPasienDetail
				 WHERE idPendaftaranPasien = @idPendaftaranPasien;
				/*UPDATE Data Pendaftaran Paasien*/
				UPDATE a
				   SET a.idJenisPerawatan = 2/*Rawat Jalan*/ 
					  ,a.idRuangan = b.idRuanganAsal
				  FROM dbo.transaksiPendaftaranPasien a
					   Inner Join dbo.transaksiOrderRawatInap b On a.idPendaftaranPasien = b.idPendaftaranPasien
				 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
				/*UPDATE Data Order Rawat Inap*/
				UPDATE dbo.transaksiOrderRawatInap
				   SET idStatusOrderRawatInap = 1/*Permintaan Rawat Inap*/
				 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Commit Tran tranzRegPasienRaNapBatalAdmisi;
			Select 'Data Pendaftaran Rawat Inap Berhasil Dihapus' As respon, 1 As responCode;
		End Try
		Begin Catch
		    Rollback Tran tranzRegPasienRaNapBatalAdmisi;
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