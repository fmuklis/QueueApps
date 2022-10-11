-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_listTindakan]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.idTindakanPasien, c.tglTindakan, c.namaRuangan, c.namaOperator, c.namaTindakan, c.biayaTindakan, c.diskonTunai, c.diskonPersen, c.jmlBiayaTindakan
		  ,c.keterangan AS statusTindakan, d.discountTindakan As flagDiscount
	  FROM dbo.transaksiBillingHeader a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
		   OUTER APPLY (SELECT xa.idTindakanPasien, xa.tglTindakan, xc.namaRuangan, xd.namaOperator, xb.namaTarif AS namaTindakan, xb.tarif AS biayaTindakan
							  ,xb.diskonTunai, xb.diskonPersen, xb.jmlTarif AS jmlBiayaTindakan, xb.keterangan
						  FROM dbo.transaksiTindakanPasien xa
							   Outer Apply dbo.getInfo_tarifTindakan(xa.idTindakanPasien) xb
							   Inner Join dbo.masterRuangan xc On xa.idRuangan = xc.idRuangan
							   Outer Apply dbo.getInfo_operatorTindakan(xa.idTindakanPasien) xd
						 WHERE xa.idPendaftaranPasien = a.idPendaftaranPasien And xa.idJenisBilling = a.idJenisBilling/* And IsNull(xa.paketPelayanan, 0) = 0
						 Union All
						Select 0 As idTindakanPasien, xa.tglTindakan, xc.namaRuangan, '' As namaOperator, xb.namaTarif As namaTindakan, xb.tarif As biayaTindakan
							  ,0  As diskonTunai, 0 As diskonPersen, xb.tarif As jmlBiayaTindakan, 'Ditagih' As statusTindakan
						  From dbo.transaksiTindakanPasien xa
							   Outer Apply dbo.getInfo_tarif(xa.idMasterTarif) xb
							   Inner Join dbo.masterRuangan xc On xa.idRuangan = xc.idRuangan
						 Where xa.idPendaftaranPasien = a.idPendaftaran And xa.idJenisBilling = a.idJenisBilling And IsNull(xa.paketPelayanan, 0) = 1*/) c
		   OUTER APPLY (SELECT discountTindakan 
						 FROM dbo.sistemKonfigurasiKasir) d
	 WHERE idBilling = @idBilling
  ORDER BY c.namaRuangan, c.tglTindakan
END