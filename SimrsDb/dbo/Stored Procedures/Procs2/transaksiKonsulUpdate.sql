-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiKonsulUpdate]
	-- Add the parameters for the stored procedure here
	@idTransaksiKonsul int
	,@idUserEntry int
	,@alasan nvarchar(max)
	,@itemKonsul nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From [dbo].[transaksiKonsul] Where idTransaksiKonsul = @idTransaksiKonsul)
		Begin
			If Exists (Select 1 From [dbo].[transaksiKonsul] Where idTransaksiKonsul = @idTransaksiKonsul And idStatusKonsul = 1)
				Begin
					UPDATE [dbo].[transaksiKonsul]
					   SET idUserEntry = @idUserEntry
						   ,alasan = @alasan
						   ,itemKonsul = @itemKonsul
					 WHERE idTransaksiKonsul = @idTransaksiKonsul;
					Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
				End
			Else
				Begin
					Select 'Tidak Dapat Diupdate, Pasien Sedang Diperiksa Dokter' as respon, 0 as responCode;
				End
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END