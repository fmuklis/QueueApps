-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_editKonsulSelesai]
	-- Add the parameters for the stored procedure here
	 @idTransaksiKonsul int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiKonsul Where idTransaksiKonsul = @idTransaksiKonsul And idStatusKonsul = 3)
		Begin
			UPDATE dbo.transaksiKonsul 
			   SET idStatusKonsul = 4  
			 WHERE idTransaksiKonsul = @idTransaksiKonsul;
					   
			Select 'Data Berhasil Diupdate' as respon ,1 as responCode;
		End
	Else
		Begin
			Select 'Data Gagal Diupdate, Pasien Belum Selesai Diperiksa Dokter' as respon ,0 as responCode;
		End
END