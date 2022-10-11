-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiOrderSelectForOrder]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idOrderDetail, a.idOrder, a.idStatusOrder, a.noOrder, a.tglOrder, be.idPabrik
		  ,a.idDistriButor, c.namaDistroButor, be.namaPabrik, a.idUserEntry, a.tglEntry
		  ,b.idObatDosis, bc.kodeObat, bc.idSatuanObat, bd.namaSatuanObat, ba.dosis, bb.namaSatuanDosis, b.jumlah,b.harga,b.discount,b.ppn,((b.harga-(b.harga*discount/100)) + ((b.harga-(b.harga*discount/100)) * b.ppn/100)) * b.jumlah as total
		  ,dbo.namaBarangFarmasi(b.idObatDosis) As namaObat
	      ,a.idStatusBayar,aa.namaStatusBayar
	  FROM dbo.farmasiOrder a
		   Left Join dbo.farmasiOrderDetail b On a.idOrder = b.idOrder
				Left Join dbo.farmasiMasterObatDosis ba On b.idObatDosis = ba.idObatDosis
				Left Join dbo.farmasiMasterObatSatuanDosis bb On ba.idSatuanDosis = bb.idSatuanDosis
				Left Join dbo.farmasiMasterObat bc On ba.idObat = bc.idObat
				left join dbo.farmasiMasterSatuanObat bd on bc.idSatuanObat = bd.idSatuanObat
				Left Join dbo.farmasiMasterPabrik be On b.idPabrik = be.idPabrik
		   Inner Join dbo.farmasiMasterDistrobutor c On a.idDistriButor = c.idDistroButor
		   inner join dbo.farmasiOrderStatusBayar aa on a.idStatusBayar = aa.idStatusBayar		   
	 WHERE a.idStatusOrder in (1,2) And a.idOrder = @idOrder;
END