
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Pasien Rawat Jalan (POLI) Yang Direkomen Rawat Inap
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderRawatinapPasienIGDInsert] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int = (Select idRuangan From transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Memastikan Pasien IGD
	If Exists(Select 1 From dbo.transaksiOrderRawatInap where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal, Pasien Telah Mendaftar' As respon, 0 As responCode;
		End
	Else
		Begin
			/*INSERT Order Rawat Inap*/
			INSERT INTO dbo.transaksiOrderRawatInap
						(idPendaftaranPasien
						,idRuanganAsal
						,idStatusOrderRawatInap
						,tglOrder)
				 VALUES (@idPendaftaranPasien
						,@idRuangan
						,1--Order Rawat Inap
						,GetDate());

			/*UPDATE Status Pendaftaran PX*/
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 4/*Order Rawat Inap*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Order Rawat Inap Berhasil' As respon, 1 As responCode;
		End
END