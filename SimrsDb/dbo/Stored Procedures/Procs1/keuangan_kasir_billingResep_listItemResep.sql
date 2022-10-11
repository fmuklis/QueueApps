-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingResep_listItemResep]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT bb.namaBarang, bb.hargaJual, bb.jumlah, bb.satuanBarang, bb.jmlHarga, bb.keterangan
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.farmasiPenjualanHeader b ON a.idResep = b.idResep
				INNER JOIN dbo.farmasiPenjualanDetail ba ON b.idPenjualanHeader = ba.idPenjualanHeader
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(ba.idPenjualanDetail) bb
	 WHERE a.idBilling = @idBilling
  ORDER BY bb.namaBarang
END