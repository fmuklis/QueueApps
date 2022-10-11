-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiRaJal_listResep]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Resep Obat Gawat Darurat, No Resep: '+ ISNULL(bb.noResep, '-') AS namaResep
		  ,SUM(bc.jmlHarga) AS jmlBiaya
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.farmasiPenjualanHeader b On a.idBilling = b.idBilling
				INNER JOIN dbo.farmasiPenjualanDetail ba On b.idPenjualanHeader = ba.idPenjualanHeader
				INNER JOIN dbo.farmasiResep bb On b.idResep = bb.idResep
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(ba.idPenjualanDetail) bc
	 WHERE a.idBilling = @idBilling
  GROUP BY bb.idResep, bb.noResep;
END