-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Menolak Order Farmasi
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiResepUpdateBatal]
	-- Add the parameters for the stored procedure here
	@idResep int
	,@idStatusResep int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From farmasiResep Where idResep = @idResep)
		Begin
			If Not Exists (Select 1 From dbo.farmasiPenjualanHeader Where idResep = @idResep)
				Begin
					UPDATE [dbo].[farmasiResep]
					   SET [idStatusResep] = @idStatusResep
					 WHERE idResep = @idResep;
					Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
				End
			Else
				Begin
					Select 'Update Gagal, Obat Pasien Telah Dientry' as respon, 0 as responCode;
				End
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END