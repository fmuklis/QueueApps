-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPembelianDelete]
	-- Add the parameters for the stored procedure here
	@idPembelianHeader int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiPembelian a
			   Where idStatusPembelian = 1 And idPembelianHeader = @idPembelianHeader)
		Begin
			DELETE [dbo].[farmasiPembelian]					
			 WHERE idPembelianHeader = @idPembelianHeader;
			Select 'Data Faktur Berhasil Dihapus' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Tidak Dapat Dihapus, Pembelian Telah Divalidasi' As respon, 0 As responCode;
		End
END