-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiRaNap_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idTindakanPasien, b.tglTindakan, bb.namaRuangan, bc.namaOperator, ba.namaTarif, ba.tarif, ba.diskonTunai, ba.diskonPersen, ba.jmlTarif
		  ,ba.keterangan
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiTindakanPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien AND a.idJenisBilling = b.idJenisBilling
				OUTER APPLY dbo.getInfo_tarifTindakan(b.idTindakanPasien) ba
				LEFT JOIN dbo.masterRuangan bb On b.idRuangan = bb.idRuangan
				OUTER APPLY dbo.getInfo_operatorTindakan(b.idTindakanPasien) bc
	 WHERE idBilling = @idBilling
  ORDER BY bb.namaRuangan, b.tglTindakan
END