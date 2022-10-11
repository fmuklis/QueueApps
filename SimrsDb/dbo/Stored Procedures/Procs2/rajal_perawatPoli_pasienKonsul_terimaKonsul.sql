-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[rajal_perawatPoli_pasienKonsul_terimaKonsul]
	-- Add the parameters for the stored procedure here
	 @idTransaksiKonsul int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiKonsul Where idTransaksiKonsul = @idTransaksiKonsul)
		Begin
			update dbo.transaksiKonsul set idStatusKonsul = 2  Where idTransaksiKonsul = @idTransaksiKonsul;
					   
			Select 'Data Berhasil Diupdate' as respon ,1 as responCode;
		End
	Else
		Begin
			Select 'Data tidak berhasil diupdate' as respon ,0 as responCode;
		End
END