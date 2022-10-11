-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderDetailDelete]
	-- Add the parameters for the stored procedure here
	@idOrderDetail int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiPembelianDetail Where idOrderDetail = @idOrderDetail)
		Begin
			Select 'Gagal!: Tidak Dapat Dihapus, Barang Farmasi Telah Sampai' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE FROM [dbo].[farmasiOrderDetail]
				  WHERE idOrderDetail = @idOrderDetail
			Select 'Data Berhasil Dihapus' As respon, 1 As responCode;
		End
END