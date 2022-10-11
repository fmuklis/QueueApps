-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_petugasRadiologi_dashboard_orderDiprosesUlang]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrder Where idOrder = @idOrder And idStatusOrder = 10)
		Begin
			/*UPDATE Data Order Radiologi*/
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 2/*Diterima*/
				  ,[keterangan] = NULL
			 WHERE idOrder = @idOrder;

			Select 'Permintaan Radiologi Diterima' As respon, 1 As responCode;
		End
END