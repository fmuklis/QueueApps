-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_dashboard_addOrder
	-- Add the parameters for the stored procedure here
	@tglOrder date,
	@idDistriButor int,
	@idOrderSumberAnggaran smallint,
	@idstatusBayar int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idOrder int = (Select idOrder From dbo.farmasiOrder Where idDistriButor = @idDistriButor And tglOrder = @tglOrder And idStatusOrder = 1)
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiOrder a Where idDistriButor = @idDistriButor And tglOrder = @tglOrder And idStatusOrder = 1)
		Begin
			Select 'Data Purchase Order Ditemukan' AS respon, 1 AS responCode, @idOrder As idOrder;
		End
	Else
		Begin
			INSERT INTO [dbo].[farmasiOrder]
					   ([idOrderSumberAnggaran]
					   ,[noOrder]
					   ,[tglOrder]
					   ,[idDistriButor]
					   ,[idUserEntry]
					   ,[idStatusBayar])
				 VALUES
					   (@idOrderSumberAnggaran
					   ,dbo.noPurchaseOrder()
					   ,@tglOrder
					   ,@idDistriButor
					   ,@idUserEntry
					   ,@idstatusBayar);

			Select 'Data Purchase Order Berhasil Disimpan' AS respon, 1 AS responCode, SCOPE_IDENTITY() As idOrder;
		End
END