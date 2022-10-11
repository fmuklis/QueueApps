-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_dashboard_editOrder
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@tglOrder date,
	@idDistriButor int,
	@idOrderSumberAnggaran smallint,
	@idstatusBayar int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiOrder a Where idDistriButor = @idDistriButor And tglOrder = @tglOrder And idStatusOrder = 1 And idOrderSumberAnggaran = @idOrderSumberAnggaran And idOrder <> @idOrder)
		Begin
			Select 'Data Purchase Order Sudah Ada' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[farmasiOrder]
			   SET [idOrderSumberAnggaran] = @idOrderSumberAnggaran
				  ,[tglOrder] = @tglOrder
				  ,[idDistriButor] = @idDistriButor
				  ,[idUserEntry] = @idUserEntry
				  ,[idStatusBayar] = @idstatusBayar
			 WHERE idOrder = @idOrder;

			Select 'Data Purchase Order Berhasil Diupdate' As respon, 1 As responCode;
		End
END