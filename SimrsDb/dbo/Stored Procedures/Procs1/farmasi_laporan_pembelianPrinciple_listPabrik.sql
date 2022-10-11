-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_laporan_pembelianPrinciple_listPabrik
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT ba.idPabrik, bb.namaPabrik
	  FROM dbo.farmasiPembelian a
		   INNER JOIN dbo.farmasiPembelianDetail b ON a.idPembelianHeader = b.idPembelianHeader
				INNER JOIN dbo.farmasiOrderDetail ba ON b.idOrderDetail = ba.idOrderDetail
				INNER JOIN dbo.farmasiMasterPabrik bb ON ba.idPabrik = bb.idPabrik
	 WHERE CAST(a.tglPembelian AS date) BETWEEN @periodeAwal AND @periodeAkhir 
  ORDER BY bb.namaPabrik
END