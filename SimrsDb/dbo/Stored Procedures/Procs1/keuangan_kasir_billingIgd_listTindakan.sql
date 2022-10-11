-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingIgd_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.idTindakanPasien, cb.namaRuangan, ca.namaTarif, ca.tarif, ca.diskonTunai, ca.diskonPersen, ca.jmlTarif
		  ,d.discountTindakan AS flagDiscount
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
		   INNER JOIN dbo.transaksiTindakanPasien c On a.idPendaftaranPasien = c.idPendaftaranPasien AND a.idJenisBilling = c.idJenisBilling
				OUTER APPLY dbo.getInfo_tarifTindakan(c.idTindakanPasien) ca
				LEFT JOIN dbo.masterRuangan cb On c.idRuangan = cb.idRuangan
		   OUTER APPLY(SELECT discountTindakan 
						 FROM dbo.sistemKonfigurasiKasir) d
	 WHERE idBilling = @idBilling
  ORDER BY cb.namaRuangan
END