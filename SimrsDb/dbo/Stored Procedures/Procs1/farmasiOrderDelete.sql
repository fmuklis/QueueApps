-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderDelete]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiOrder Where idStatusOrder = 1)
		Begin
			DELETE FROM [dbo].[farmasiOrder]
				  WHERE idOrder = @idOrder;
			Select 'Data Berhasil Dihapus' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Tidak Dapat Dihapus, Pesanan Sudah Selesai' As respon, 0 As responCode;
		End
END