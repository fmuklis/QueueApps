
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	Pembatalan Ranap Pasien Rajal
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderRawatinapPasienIGDBatal] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int = (Select idRuangan From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiOrderRawatInap Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrderRawatInap In(1/*Order Ranap*/,4))
		Begin
			Select 'Gagal, Pasien Telah '+ b.statusOrderRawatInap As respon, 0 As responCode
			  From dbo.transaksiOrderRawatInap a
				   Inner Join dbo.masterStatusOrderRawatInap b On a.idStatusOrderRawatInap = b.idStatusOrderRawatInap
			 Where idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin
			DELETE FROM [dbo].[transaksiOrderRawatInap]
				  WHERE idPendaftaranPasien = @idPendaftaranPasien;

			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 3/*Dalam Perawatan IGD*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			Select 'Order Rawat Inap Dibatalkan' as respon, 1 as responCode;
		End
END