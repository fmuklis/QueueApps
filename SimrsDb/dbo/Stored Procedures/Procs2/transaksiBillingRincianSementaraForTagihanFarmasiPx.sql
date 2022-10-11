-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingRincianSementaraForTagihanFarmasiPx]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResep, a.tglResep, 'Resep '+ ca.namaJenisRuangan +' No: '+ a.noResep As namaResep, d.NamaOperator As namaDokter
		  ,bc.namaBarang As namaObat, ba.jumlah, bc.namaSatuanObat , ba.hargaJual
		  ,Case
				When ba.ditagih = 1
					 Then ba.hargaJual * ba.jumlah
				Else 0
			End As jmlHarga 
	  FROM dbo.farmasiResep a
		   Inner Join dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
				Inner Join dbo.farmasiPenjualanDetail ba On b.idPenjualanHeader = ba.idPenjualanHeader
				Inner Join dbo.farmasiMasterObatDetail bb On ba.idObatDetail = bb.idObatDetail
				Cross Apply dbo.getInfo_barangFarmasi(bb.idObatDosis) bc
		   Inner Join dbo.masterRuangan c On a.idRuangan = c.idRuangan
				Inner Join dbo.masterRuanganJenis ca On c.idJenisRuangan = ca.idJenisRuangan
		   Inner Join dbo.masterOperator d On a.idDokter = d.idOperator
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien And b.idBilling Is Null
  ORDER BY a.idResep
END