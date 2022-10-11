-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectCetakDetailTagihanFarmasiRaNap]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT b.idResep, b.tglJual, 'Resep '+ be.namaJenisRuangan +' No: '+ IsNull(bc.noResep, '') As namaTarif, bf.namaBarang As namaObat
		  ,ba.hargaJual, ba.jumlah
		  ,Case
				When ba.ditagih = 1
					 Then ba.hargaJual * ba.jumlah
				Else 0
			End As jmlHarga 
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.farmasiPenjualanHeader b On a.idBilling = b.idBilling
				Inner Join dbo.farmasiPenjualanDetail ba On b.idPenjualanHeader = ba.idPenjualanHeader
				Inner Join dbo.farmasiMasterObatDetail bb On ba.idObatDetail = bb.idObatDetail
				Inner Join dbo.farmasiResep bc On b.idResep = bc.idResep
				Inner Join dbo.masterRuangan bd On bc.idRuangan = bd.idRuangan
				Inner Join dbo.masterRuanganJenis be On bd.idJenisRuangan = be.idJenisRuangan
				Cross Apply dbo.getInfo_barangFarmasi(bb.idObatDosis) bf
	 WHERE a.idBilling = @idBilling
 -- GROUP BY b.tglJual, be.namaJenisRuangan, b.idResep, bc.noResep
  ORDER BY b.idResep
END