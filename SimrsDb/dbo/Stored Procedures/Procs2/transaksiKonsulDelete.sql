-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiKonsulDelete]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idTransaksiKonsul int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiKonsul Where idPendaftaranPasien = @idPendaftaranPasien and idTransaksiKonsul = @idtransaksiKonsul And idStatusKonsul = 1)
		Begin
			Delete From dbo.transaksiKonsul  Where idPendaftaranPasien = @idPendaftaranPasien And idTransaksiKonsul = @idtransaksiKonsul And idStatusKonsul = 1
					   
			Select 'Data Berhasil Dihapus' as respon ,1 as responCode;
		End
	Else
		Begin
			Select 'Tidak Dapat Dihapus, Pasien Telah Diterima' as respon ,0 as responCode;
		End
END