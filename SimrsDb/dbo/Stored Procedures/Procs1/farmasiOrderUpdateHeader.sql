-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderUpdateHeader]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@tglOrder Date,
	@idDistriButor int, --PBF/supllier
	@idStatusBayar int ---payment of type

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[farmasiOrder]
	   SET [tglOrder] = @tglOrder
		  ,[idDistriButor] = @idDistriButor
		  ,[idStatusBayar] = @idStatusBayar
	 WHERE idOrder = @idOrder;
 Select 'Data Berhasil Diupdate' As respon,1 As responCode;
END