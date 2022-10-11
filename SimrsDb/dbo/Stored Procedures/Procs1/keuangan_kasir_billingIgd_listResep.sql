-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingIgd_listResep]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Resep Unit Gawat Darurat, No Resep: '+ a.noResep AS namaResep, SUM(ca.jmlHarga) AS biayaResep
	  FROM dbo.farmasiResep a 
		   INNER JOIN dbo.farmasiPenjualanHeader b ON a.idResep = b.idResep
				INNER JOIN dbo.farmasiPenjualanDetail ba On b.idPenjualanHeader = ba.idPenjualanHeader
				OUTER APPLY dbo.getInfo_biayaPenjualanResep(ba.idPenjualanDetail) ca
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien And b.idStatusPenjualan = 2/*Siap Bayar*/
  GROUP BY a.noResep
END