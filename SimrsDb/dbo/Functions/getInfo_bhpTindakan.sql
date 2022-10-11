-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_bhpTindakan]
(	
	-- Add the parameters for the function here
	@idTindakanPasien int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idPenjualanDetail, a.jumlah As jmlBHP, a.hargaJual As tarifBHP
		  ,ba.namaBarang +' Batch: '+ b.kodeBatch +' Exp: '+ CAST(b.tglExpired AS varchar(50)) +' Jml: '+ CAST(a.jumlah AS varchar(50)) +' @ '+ CAST(a.hargaJual AS varchar(50)) +'/'+ ba.namaSatuanObat AS namaBHP
		  ,c.namaLengkap AS petugas
		  ,CASE
				WHEN a.ditagih = 1
					 THEN CAST(a.jumlah * a.hargaJual AS int)
				ELSE 0
		    END AS jmlTarifBHP
		  ,CASE
				WHEN a.ditagih = 1
					 THEN 'Ditagih'
				ELSE 'Tidak Ditagih'
		    END AS keterangan
	  FROM dbo.farmasiPenjualanDetail a
		   INNER JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
				CROSS APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
		   LEFT JOIN dbo.masterUser c ON a.idUserEntry = c.idUser
	 WHERE a.idTindakanPasien = @idTindakanPasien
)