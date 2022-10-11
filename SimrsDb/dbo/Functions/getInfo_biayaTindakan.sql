-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_biayaTindakan]
(
	-- Add the parameters for the function here
	@idTindakanPasien int
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT cc.namaTarifPaket As namaPaket, ca.namaTarifHeader As namaTindakan, cc.tarif As biayaPaket, Sum(b.nilai) As biayaTindakan, b.jumlah As jumlahTindakan
		  ,IsNull(a.diskonPersen, 0) As diskonPersen, IsNull(a.diskonTunai, 0) As diskonTunai, c.flagTidakDijaminBPJS, ca.idMasterTarifGroup, cd.orderNumber AS tarifGroupOrder, cd.namaTarifGroup
		  ,Case
				When a.flagPaket = 1
					 Then 0
				Else Sum(b.nilai) - IsNull(a.diskonTunai, 0) - ((Sum(b.nilai) - IsNull(a.diskonTunai, 0)) * IsNull(a.diskonPersen, 0) / 100)
			End As jmlBiayaTindakan
		  ,Case
				When a.flagPaket = 1
					 Then 0
				Else 1
			End As penagihanTindakan
		  ,Case
				When a.flagPaket = 1
					 Then 'Paket/Tdk Ditagih'
				Else 'Ditagih'
			End As statusTindakan
	  FROM dbo.transaksiTindakanPasien a
		   LEFT JOIN dbo.transaksiTindakanPasienDetail b ON a.idTindakanPasien = b.idTindakanPasien
		   INNER JOIN dbo.masterTarip c On a.idMasterTarif = c.idMasterTarif				
				INNER JOIN dbo.masterTarifHeader ca On c.idMasterTarifHeader = ca.idMasterTarifHeader
				LEFT JOIN dbo.masterPaketPelayanan cb On c.idMasterPaketPelayanan = cb.idMasterPaketPelayanan
				LEFT JOIN dbo.masterTarifPaket cc On cb.idMasterTarifPaket = cc.idMasterTarifPaket
				LEFT JOIN dbo.masterTarifGroup cd ON ca.idMasterTarifGroup = cd.idMasterTarifGroup
		   LEFT JOIN dbo.masterRuangan d On a.idRuangan = d.idRuangan
	 WHERE a.idTindakanPasien = @idTindakanPasien
  GROUP BY cc.namaTarifPaket, ca.namaTarifHeader, cc.tarif, b.jumlah, a.flagPaket, a.diskonPersen, a.diskonTunai, c.flagTidakDijaminBPJS, ca.idMasterTarifGroup, cd.orderNumber, cd.namaTarifGroup
)