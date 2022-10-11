-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPenjualanFarmasiSelectByidPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResep, c.noResep, a.tglJual, dbo.namaBarangFarmasi(ba.idObatDosis) As namaObat, bd.namaSatuanObat, b.hargaJual, b.jumlah, Sum(b.hargaJual * b.jumlah) As total
		  ,'Resep '+ cb.namaJenisRuangan As namaResep
	  FROM dbo.farmasiPenjualanHeader a
		   Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanHeader = b.idPenjualanHeader
				Inner Join dbo.farmasiMasterObatDetail ba On b.idObatDetail = ba.idObatDetail
				Inner Join dbo.farmasiMasterObatDosis bb On ba.idObatDosis = bb.idObatDosis
				Inner Join dbo.farmasiMasterObat bc On bb.idObat = bc.idObat
				Inner Join dbo.farmasiMasterSatuanObat bd On bc.idSatuanObat = bd.idSatuanObat
		   Inner Join dbo.farmasiResep c On a.idResep = c.idResep
				Inner Join dbo.masterRuangan ca On c.idRuangan = ca.idRuangan
				Inner Join dbo.masterRuanganJenis cb On ca.idJenisRuangan = cb.idJenisRuangan
	 WHERE c.idPendaftaranPasien = @idPendaftaranPasien
  GROUP BY a.idResep, c.noResep, a.tglJual, ba.idObatDosis, bc.namaObat, bd.namaSatuanObat, b.hargaJual, b.jumlah, cb.namaJenisRuangan
  ORDER BY a.idResep, bc.namaObat
END