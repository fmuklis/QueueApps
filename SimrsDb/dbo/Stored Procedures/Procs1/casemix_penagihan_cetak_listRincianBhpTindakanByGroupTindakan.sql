-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_cetak_listRincianBhpTindakanByGroupTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.idTindakanBHP, 'BMHP' AS namaTarifGroup, b.tglTindakan, bc.namaRuangan, ba.namaBHP, bd.namaOperator
		  ,ba.tarifBHP, ba.jumlahBHP, 0 AS diskonTunai, 0 AS diskonPersen, ba.jumlahTarifBHP
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiTindakanPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				CROSS APPLY dbo.getInfo_biayaBHP(b.idTindakanPasien) ba
				LEFT JOIN dbo.masterRuangan bc ON b.idRuangan = bc.idRuangan
				OUTER APPLY dbo.getInfo_operatorTindakan(b.idTindakanPasien) bd
	 WHERE idBilling = @idBilling
  ORDER BY idTindakanPasien
END