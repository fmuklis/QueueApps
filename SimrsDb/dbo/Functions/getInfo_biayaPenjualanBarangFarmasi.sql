-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_biayaPenjualanBarangFarmasi]
(
	-- Add the parameters for the function here
	@idPenjualanHeader bigint
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idPenjualanDetail, ba.idMasterTarifGroup, ba.kategoriBarang, ba.kategoriBarangOrder
		  ,ba.namaBarang, a.jumlah, ba.satuanBarang, a.hargaJual
		  ,CASE
				WHEN a.flagPaket = 1
					 THEN 0
				ELSE a.hargaJual * a.jumlah 
			END AS jmlHarga
		  ,CASE
				WHEN a.flagPaket = 1
					 THEN 'Paket/Tdk Ditagih'
				ELSE 'Ditagih'
			END AS keterangan
	  FROM dbo.farmasiPenjualanDetail a
		   INNER JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
				CROSS APPLY dbo.getInfo_barangFarmasiDetail(b.idObatDosis) ba
	 WHERE a.idPenjualanHeader = @idPenjualanHeader
)