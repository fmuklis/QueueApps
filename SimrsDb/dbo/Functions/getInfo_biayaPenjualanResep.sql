-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_biayaPenjualanResep]
(
	-- Add the parameters for the function here
	@idPenjualanDetail bigint

)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idPenjualanDetail, ba.kategoriBarang, ba.namaBarang, a.jumlah, ba.satuanBarang, CAST(a.hargaJual AS int) AS hargaJual
		  ,CASE
				WHEN a.ditagih = 1
					 THEN CAST(a.hargaJual * a.jumlah AS int)
				ELSE 0
			END AS jmlHarga
		  ,CASE
				WHEN a.ditagih = 1
					 THEN 'Ditagih'
				ELSE 'Paket/Tdk Ditagih'
			END AS keterangan
	  FROM dbo.farmasiPenjualanDetail a
		   LEFT JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasiDetail(b.idObatDosis) ba
	 WHERE a.idPenjualanDetail = @idPenjualanDetail
)