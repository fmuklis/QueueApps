-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPembelianByidOrder]
	-- Add the parameters for the stored procedure here
	@idorder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idOrderDetail,a.noOrder,a.idDistriButor,f.namaDistroButor,f.telepon, a.idStatusOrder,a.idUserEntry,a.tglOrder,e.namaSatuanObat
		  ,c.idObat, c.idObatDosis, d.kodeObat, dbo.namaBarangFarmasi(c.idObatDosis) As namaObat
		   ,d.idSatuanObat,b.jumlah As jumlahOrder,  c.dosis,c.idSatuanDosis,ca.namaSatuanDosis 
		   ,ga.idPembelianHeader, ga.noFaktur, ga.tglPembelian, g.idPembelianDetail, g.jumlahBeli, g.discountPersen, g.discountUang, g.hargaBeli, g.kodeBatch, g.tglExpired,ga.tglJatuhTempoPembayaran
	  FROM dbo.farmasiOrder a
		   Inner Join dbo.farmasiOrderDetail b on a.idOrder = b.idOrder
		   Inner Join dbo.farmasiMasterObatDosis c on b.idObatDosis = c.idObatDosis
		   Inner Join dbo.farmasiMasterObatSatuanDosis ca on c.idSatuanDosis = ca.idSatuanDosis
		   Inner Join dbo.farmasiMasterObat d on c.idObat = d.idObat
		   Inner Join dbo.farmasiMasterSatuanObat e on d.idSatuanObat = e.idSatuanObat
		   Inner Join dbo.farmasiMasterDistrobutor f on a.idDistriButor = f.idDistrobutor
		   Left Join dbo.farmasiPembelianDetail g On b.idOrderDetail = g.idOrderDetail
				Left Join dbo.farmasiPembelian ga On g.idPembelianHeader = ga.idPembelianHeader
	 WHERE b.idOrder = @idorder
END