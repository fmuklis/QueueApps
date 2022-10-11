-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiResep_listResep]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT On added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	SELECT bb.namaBarang, ba.jumlah, bb.satuanBarang, ba.hargaJual, bb.jmlHarga
	  FROM dbo.transaksiBillingHeader a	
		   INNER JOIN dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
				INNER JOIN dbo.farmasiPenjualanDetail ba ON b.idPenjualanHeader = ba.idPenjualanHeader
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(ba.idPenjualanDetail) bb
	WHERE a.idBilling = @idBilling
 ORDER BY bb.namaBarang;
END