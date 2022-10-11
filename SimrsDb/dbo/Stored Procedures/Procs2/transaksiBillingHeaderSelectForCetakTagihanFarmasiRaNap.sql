-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectForCetakTagihanFarmasiRaNap]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.
	Declare @idBilling int = (Select idBilling From dbo.transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaranPasien And idJenisBilling = 5/*Billing RaNap*/) ;
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT dbo.namaBarangFarmasi(ba.idObatDosis) As namaObat, b.hargaJual As hargaSatuan, b.hargaJual * jumlah As Harga
		  ,b.jumlah, bd.namaSatuanObat
	  FROM dbo.farmasiPenjualanHeader a 
		   Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanHeader = b.idPenjualanHeader
				Inner Join dbo.farmasiMasterObatDetail ba On b.idObatDetail = ba.idObatDetail
				Inner Join dbo.farmasiMasterObatDosis bb On ba.idObatDosis = bb.idObatDosis
				Inner Join dbo.farmasiMasterObat bc On bb.idObat = bc.idObat
				Inner Join dbo.farmasiMasterSatuanObat bd On bc.idSatuanObat = bc.idSatuanObat
	 WHERE a.idBilling = @idBilling
  ORDER BY a.idResep, bc.namaObat
END