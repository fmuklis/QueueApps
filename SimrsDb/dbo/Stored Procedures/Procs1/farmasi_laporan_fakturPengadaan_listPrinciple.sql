-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Data Distributor Farmasi
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_fakturPengadaan_listPrinciple]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idDistrobutor int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT ba.idPabrik, bb.namaPabrik
	  FROM dbo.farmasiPembelian a
		   INNER JOIN dbo.farmasiPembelianDetail b ON a.idPembelianHeader = b.idPembelianHeader 
				INNER JOIN farmasiOrderDetail ba ON b.idOrderDetail = ba.idOrderDetail
				INNER JOIN dbo.farmasiMasterPabrik bb ON ba.idPabrik = bb.idPabrik
				INNER JOIN dbo.farmasiOrder bc ON ba.idOrder = bc.idOrder
	 WHERE a.tglPembelian BETWEEN @periodeAwal And @periodeAkhir AND bc.idDistriButor = @idDistrobutor
  ORDER BY bb.namaPabrik
END