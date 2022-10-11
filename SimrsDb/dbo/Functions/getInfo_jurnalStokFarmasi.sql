-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_jurnalStokFarmasi]
(	
	-- Add the parameters for the function here
	@idLog bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT COALESCE(b.keterangan, c.keterangan, d.keterangan, e.keterangan, g.keterangan, f.keterangan) AS keterangan
		  ,COALESCE(b.ruangan, c.ruangan, d.ruangan, e.ruangan, g.ruangan, f.ruangan) AS ruangan
	  FROM dbo.farmasiJurnalStok a
		   OUTER APPLY dbo.getInfo_jurnalPembelian(a.idPembelianDetail) b
		   OUTER APPLY dbo.getInfo_jurnalPenjualan(a.idPenjualanDetail) c
		   OUTER APPLY dbo.getInfo_jurnalStokOpname(a.idStokOpnameDetail) d
		   OUTER APPLY dbo.getInfo_jurnalMutasi(a.idLog) e
		   OUTER APPLY dbo.getInfo_jurnalRetur(a.idLog) f
		   OUTER APPLY dbo.getInfo_jurnalPenghapusanBarangFarmasi(a.idPenghapusanStokDetail) g
	 WHERE a.idLog = @idLog
)