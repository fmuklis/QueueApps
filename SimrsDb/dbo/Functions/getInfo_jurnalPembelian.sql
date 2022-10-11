-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION getInfo_jurnalPembelian
(	
	-- Add the parameters for the function here
	@idPembelianDetail bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 'Penerimaan Barang Farmasi Tgl: '+ CAST(CONVERT(date, a.tglPembelian, 108) AS varchar(15)) +' No Faktur: '+ a.noFaktur AS keterangan
		  ,'Gudang Farmasi' AS ruangan
	  FROM dbo.farmasiPembelian a
		   LEFT JOIN dbo.farmasiPembelianDetail b ON a.idPembelianHeader = b.idPembelianHeader
	 WHERE b.idPembelianDetail = @idPembelianDetail
)