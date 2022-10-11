-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_dashboard_update_orderDiprosesUlang]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 FRom dbo.transaksiOrder Where idOrder = @idOrder And idStatusOrder = 10)
		Begin
			/*UPDATE Data Order Labor*/
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 2/*Diterima*/
				  ,[keterangan] = NULL
			 WHERE idOrder = @idOrder;

			Select 'Permintaan Laboratorium Diterima' As respon, 1 As responCode;
		End
END