-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiKonsulDitolak]
	-- Add the parameters for the stored procedure here
	 @idTransaksiKonsul int

AS
BEGIN
	Declare @idPendaftaranPasien int;
	Declare @idRuangan int;
	
	Select @idPendaftaranPasien = idPendaftaranPasien,@idRuangan = idRuanganTujuan from transaksiKonsul where idTransaksiKonsul = @idTransaksiKonsul;

	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiKonsul Where idTransaksiKonsul = @idTransaksiKonsul and idStatusKonsul = 2)
		Begin
			If not exists(Select 1 from transaksiTindakanPasien where idPendaftaranPasien = @idPendaftaranPasien
			and idRuangan = @idRuangan)
			Begin
				update dbo.transaksiKonsul set idStatusKonsul = 1  Where idTransaksiKonsul = @idTransaksiKonsul and idStatusKonsul = 2;
				Select 'Data Berhasil Diupdate' as respon ,1 as responCode;
			End
			else
			Begin
				Select 'Data tidak bisa dibatalkan karena sudah ada entry tindakan di konsul ini' as respon ,0 as responCode;
			End
		End
	Else
		Begin
			Select 'Data tidak berhasil diupdate' as respon ,0 as responCode;
		End
END