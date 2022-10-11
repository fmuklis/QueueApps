-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiKonsulBatal]
	-- Add the parameters for the stored procedure here
	@idTransaksiKonsul int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiTindakanPasien a
					 Inner Join dbo.transaksiBillingHeader b On a.idPendaftaranPasien = b.idPendaftaranPasien And a.idJenisBilling = b.idJenisBilling
			   Where a.idTransaksiKonsul = @idTransaksiKonsul And b.idJenisBayar Is Not Null)
		Begin
			Select 'Tidak Dapat Dibatalkan, Pasien Telah Membayar Untuk Konsul Ini' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE dbo.transaksiTindakanPasien
			 WHERE idTransaksiKonsul = @idTransaksiKonsul;

			UPDATE dbo.transaksiKonsul
			   SET idStatusKonsul = 1
			 WHERE idTransaksiKonsul = @idTransaksiKonsul;
			Select 'Pemeriksaan Konsul Berhasil Dibatalkan' as respon, 1 as responCode;
		End
END