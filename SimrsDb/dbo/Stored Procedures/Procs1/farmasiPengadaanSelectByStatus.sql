-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPengadaanSelectByStatus]
	-- Add the parameters for the stored procedure here
	@idStatusOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.[idOrder], a.[idStatusOrder], [noOrder], [tglOrder]
		   ,[idDistriButor], b.namaDistroButor, a.idStatusOrder, c.namaStatusOrder
	  FROM [dbo].[farmasiOrder] a
		   Inner Join dbo.farmasiMasterDistrobutor b On a.idDistriButor = b.idDistrobutor
		   Inner Join dbo.farmasiOrderStatus c on a.idStatusOrder = c.idStatusOrder
	 WHERE a.idStatusOrder In(1,2)-- @idStatusOrder;
END