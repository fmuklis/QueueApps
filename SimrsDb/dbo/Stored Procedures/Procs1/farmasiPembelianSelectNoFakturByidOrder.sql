-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPembelianSelectNoFakturByidOrder]
	-- Add the parameters for the stored procedure here
	@idorder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idDistrobutor int = (Select idDistriButor From dbo.farmasiOrder Where idOrder = @idorder)
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.noFaktur, a.tglPembelian, a.tglJatuhTempoPembayaran, a.keterangan, a.idPembelianHeader, a.ppn, a.idStatusPembelian
	  FROM dbo.farmasiPembelian a
		   Inner Join dbo.farmasiOrder b on a.idOrder = b.idOrder
	 WHERE a.idOrder = @idorder And (b.idStatusOrder < 3 Or(b.idStatusOrder = 3 And a.idStatusPembelian = 1))
END