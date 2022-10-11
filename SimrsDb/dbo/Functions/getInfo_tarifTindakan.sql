-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_tarifTindakan]
(	
	-- Add the parameters for the function here
	@idTindakanPasien int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT bc.namaTarifGroup, ba.namaTarifHeader AS namaTarif, bb.namaKelas AS kelasTarif, a.qty, CAST(c.tarif AS int) AS tarif, ba.BHP
		  ,a.diskonTunai, a.diskonPersen
		  ,CASE
				WHEN a.ditagih = 1
					 THEN CAST((a.qty * c.tarif) - a.diskonTunai - (((a.qty * c.tarif) - a.diskonTunai) * a.diskonPersen / 100) AS int)
				ELSE 0
		    END AS jmlTarif
		  ,CASE
				WHEN a.ditagih = 1
					 THEN 'Ditagih'
				ELSE 'Tidak Ditagih'
		    END AS keterangan
	  FROM dbo.transaksiTindakanPasien a
		   INNER JOIN dbo.masterTarip b ON a.idMasterTarif = b.idMasterTarif
				LEFT JOIN dbo.masterTarifHeader ba ON b.idMasterTarifHeader = ba.idMasterTarifHeader
				LEFT JOIN dbo.masterKelas bb ON b.idKelas = bb.idKelas
				LEFT JOIN dbo.masterTarifGroup bc ON ba.idMasterTarifGroup = bc.idMasterTarifGroup
		   OUTER APPLY (SELECT SUM(xa.nilai) AS tarif
						  FROM dbo.transaksiTindakanPasienDetail xa
						 WHERE xa.idTindakanPasien = a.idTindakanPasien) c
	 WHERE a.idTindakanPasien = @idTindakanPasien
)