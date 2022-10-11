-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderInsert] 
	-- Add the parameters for the stored procedure here
	@tglOrder date
	,@idDistriButor int
	,@idUserEntry int
	,@idstatusBayar int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idOrder int = (Select idOrder From dbo.farmasiOrder Where idDistriButor = @idDistriButor And tglOrder = @tglOrder And idStatusOrder = 1)
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.farmasiOrder a Where idDistriButor = @idDistriButor And tglOrder = @tglOrder And idStatusOrder = 1)
		Begin
			INSERT INTO [dbo].farmasiOrder
					   ([idStatusOrder]
					   ,[noOrder]
					   ,[tglOrder]
					   ,[idDistriButor]
					   ,[idUserEntry]
					   ,[tglEntry]
					   ,idStatusBayar)
				 VALUES
					   (1
					   ,dbo.noPurchaseOrder()
					   ,@tglOrder
					   ,@idDistriButor
					   ,@idUserEntry
					   ,Getdate()
					   ,@idstatusBayar);
			Select 'Data Purchase Order Berhasil Disimpan' As respon, 1 As responCode, SCOPE_IDENTITY() As idOrder;
		End
	Else
		Begin
			Select 'Data Purchase Order Sudah Ada' As respon, 0 As responCode, @idOrder As idOrder;
		End
END