-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderRadioDiterimaUpdate]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrder a
			   Where a.idOrder = @idOrder And a.idStatusOrder = 1)
		Begin
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 2/*Diterima*/
			 WHERE idOrder = @idOrder;
			Select 'Permintaan Rradiologi Diterima' As respon, 1 As responCode;
		End
END