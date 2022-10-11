-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPembelianDetailDelete]
	-- Add the parameters for the stored procedure here
	@idPembelianDetail int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiMasterObatDetail a
			   Where a.idPembelianDetail = @idPembelianDetail)
		Begin
			Select 'Tidak Dapat Dihapus, Pembelian Telah Divalidasi' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE [dbo].[farmasiPembelianDetail]
			 WHERE idPembelianDetail = @idPembelianDetail;
			Select 'Data Berhasil Dihapus' As respon, 1 As responCode;
		End
END