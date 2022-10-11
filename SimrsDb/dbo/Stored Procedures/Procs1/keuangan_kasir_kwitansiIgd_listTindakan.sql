-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_kwitansiIgd_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idTindakanPasien, ba.namaTarif, ba.tarif, ba.qty, ba.diskonTunai, ba.diskonPersen, ba.jmlTarif
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiTindakanPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien AND a.idJenisBilling = b.idJenisBilling
				OUTER APPLY dbo.getInfo_tarifTindakan(b.idTindakanPasien) ba
	 WHERE a.idBilling = @idBilling
  ORDER BY b.idTindakanPasien
END