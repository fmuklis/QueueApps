-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_tarif]
(	
	-- Add the parameters for the function here
	@idMasterTarif int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idMasterTarifHeader, b.namaTarifHeader AS namaTarif, c.namaKelas AS kelasTarif, b.BHP
		  ,e.namaSatuanTarif AS satuanTarif, SUM(d.tarip) AS nilaiTarif
		  ,CASE
				WHEN a.idSatuanTarif = 4
					 THEN 0
				ELSE 1
			END AS flagQty
	  FROM dbo.masterTarip a
		   LEFT JOIN dbo.masterTarifHeader b On a.idMasterTarifHeader = b.idMasterTarifHeader
		   LEFT JOIN dbo.masterKelas c On a.idKelas = c.idKelas
		   LEFT JOIN dbo.masterTaripDetail d ON a.idMasterTarif = d.idMasterTarip AND d.[status] = 1/*Aktif*/
		   LEFT JOIN dbo.masterSatuanTarif e ON a.idSatuanTarif = e.idSatuanTarif
	 WHERE a.idMasterTarif = @idMasterTarif
  GROUP BY a.idMasterTarifHeader, b.namaTarifHeader, c.namaKelas, b.BHP,a.idSatuanTarif, e.namaSatuanTarif
)