-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPembelianPrincipleSelectPabrik]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct ba.idPabrik, bb.namaPabrik
	  FROM dbo.farmasiPembelian a
		   Inner Join dbo.farmasiPembelianDetail b On a.idPembelianHeader = b.idPembelianHeader
				Inner Join dbo.farmasiOrderDetail ba On b.idOrderDetail = ba.idOrderDetail
				Inner Join dbo.farmasiMasterPabrik bb On ba.idPabrik = bb.idPabrik
	 WHERE Convert(date, a.tglPembelian) Between @periodeAwal And @periodeAkhir 
  ORDER BY bb.namaPabrik
END