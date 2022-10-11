-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[getInfo_pemeriksaanLaboratorium]
(	
	-- Add the parameters for the function here
	@idMasterTarifHeader int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT ca.idDetailItemPemeriksaanLaboratorium, b.idGolonganPemeriksaanLaboratorium, ba.golonganPemeriksaan, ba.nomorUrut AS nomorUrutGolongan
		  ,b.idJenisPemeriksaanLaboratorium, TRIM('-' FROM b.jenisPemeriksaan) AS jenisPemeriksaan, b.nomorUrut AS nomorUrutJenis
		  ,a.idPemeriksaanLaboratorium, d.namaTarifHeader AS pemeriksaan, a.nomorUrut AS nomorUrutPemeriksaan
		  ,CASE
			    WHEN c.multiItem = 1
					 THEN c.itemPemeriksaan
				ELSE NULL
			END AS itemPemeriksaan		  
		  ,c.nomorUrut AS nomorUrutItemPemeriksaan, c.multiItem
		  ,CASE
			    WHEN c.multiItem = 1
					 THEN '- '+	ca.detailItemPemeriksaan
				ELSE ca.detailItemPemeriksaan
			END AS detailItemPemeriksaan, ca.satuan, ca.nilaiRujukan, ca.nomorUrut AS nomorUrutDetailPemeriksaan
	  FROM dbo.masterLaboratoriumPemeriksaan a
		   LEFT JOIN dbo.masterLaboratoriumPemeriksaanJenis b ON a.idJenisPemeriksaanLaboratorium = b.idJenisPemeriksaanLaboratorium
				LEFT JOIN dbo.masterLaboratoriumPemeriksaanGolongan ba ON b.idGolonganPemeriksaanLaboratorium = ba.idGolonganPemeriksaanLaboratorium
		   LEFT JOIN dbo.masterLaboratoriumPemeriksaanItem c ON a.idPemeriksaanLaboratorium = c.idPemeriksaanLaboratorium AND c.aktif = 1/*Item Pemeriksaan Yg Aktif*/
				LEFT JOIN dbo.masterLaboratoriumPemeriksaanItemDetail ca ON c.idItemPemeriksaanLaboratorium = ca.idItemPemeriksaanLaboratorium AND ca.aktif = 1/*Item Pemeriksaan Yg Aktif*/
		   LEFT JOIN dbo.masterTarifHeader d ON a.idMasterTarifHeader = d.idMasterTarifHeader
	 WHERE a.idMasterTarifHeader = @idMasterTarifHeader
)