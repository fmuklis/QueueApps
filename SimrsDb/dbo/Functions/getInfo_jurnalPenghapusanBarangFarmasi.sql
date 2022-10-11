-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION getInfo_jurnalPenghapusanBarangFarmasi
(	
	-- Add the parameters for the function here
	@idPenghapusanStokDetail bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 'Penghapusan Barang Expired Tgl: '+ CAST(CONVERT(date, b.tanggalPenghapusan, 108) AS varchar(20)) AS keterangan
		  ,'Gudang Farmasi' AS ruangan
	  FROM dbo.farmasiPenghapusanStokDetail a
		   INNER JOIN dbo.farmasiPenghapusanStok b ON a.idPenghapusanStok = b.idPenghapusanStok
	 WHERE a.idPenghapusanStokDetail = @idPenghapusanStokDetail
)