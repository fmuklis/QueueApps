-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPersediaanFarmasiItem]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT a.idObatDosis, kodeObat, b.namaBarang AS namaObat, cb.namaGolonganObat AS namaJenisPenjaminInduk
		  ,b.hargaJual, b.satuanBarang AS namaSatuanObat, ca.jumlahHariPeringatanKadaluarsa, cc.namaJenisObat
	  FROM dbo.farmasiMasterObatDetail a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   LEFT JOIN dbo.farmasiMasterObatDosis c ON a.idObatDosis = c.idObatDosis
				LEFT JOIN dbo.farmasiMasterObat ca ON c.idObat = ca.idObat
				LEFT JOIN dbo.farmasiMasterObatGolongan cb ON ca.idGolonganObat = cb.idGolonganObat
				LEFT JOIN dbo.farmasiMasterObatJenis cc ON ca.idJenisObat = cc.idJenisOBat
	 WHERE a.stok >= 1
  ORDER BY b.namaBarang
END